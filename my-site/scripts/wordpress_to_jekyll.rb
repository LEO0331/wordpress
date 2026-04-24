#!/usr/bin/env ruby
# frozen_string_literal: true

require 'cgi'
require 'fileutils'
require 'optparse'
require 'rexml/document'
require 'uri'
require 'yaml'
require 'pathname'

class WordpressToJekyll
  URL_RE = %r{https?://[^\s"'<>]+}.freeze

  def initialize(site_root:, xml_path:, posts_dir:, dry_run:)
    @site_root = File.expand_path(site_root)
    @xml_path = File.expand_path(xml_path)
    @posts_dir = File.expand_path(posts_dir, @site_root)
    @dry_run = dry_run

    @stats = {
      total_items: 0,
      selected_posts: 0,
      written_posts: 0,
      skipped_collisions: 0,
      image_urls_rewritten: 0
    }
    @collisions = []
    @unmatched_image_urls = Hash.new(0)
  end

  def run
    ensure_paths
    xml_text = File.read(@xml_path)
    validate_xml_safety!(xml_text)
    doc = REXML::Document.new(xml_text)

    doc.elements.each('rss/channel/item') do |item|
      @stats[:total_items] += 1
      next unless post_item?(item)

      @stats[:selected_posts] += 1
      write_post(item)
    end

    print_report
  end

  private

  def ensure_paths
    abort("XML not found: #{@xml_path}") unless File.file?(@xml_path)
    return if File.directory?(@posts_dir)

    abort("Posts dir not found: #{@posts_dir}") if @dry_run
    FileUtils.mkdir_p(@posts_dir)
  end

  def post_item?(item)
    post_type = text(item, 'wp:post_type')
    status = text(item, 'wp:status')
    post_type == 'post' && status == 'publish'
  end

  def write_post(item)
    date_text = text(item, 'wp:post_date')
    raw_slug = text(item, 'wp:post_name')
    slug = sanitize_slug(raw_slug)
    slug = slugify(text(item, 'title')) if slug.empty?

    unless valid_date?(date_text)
      warn "Skipping post with invalid date: #{text(item, 'title')}"
      return
    end

    filename = "#{date_text[0, 10]}-#{slug}.md"
    output_path = safe_post_output_path(filename)
    unless output_path
      warn "Skipping post with unsafe output path: #{text(item, 'title')}"
      return
    end

    if File.exist?(output_path)
      @stats[:skipped_collisions] += 1
      @collisions << output_path
      return
    end

    content = text(item, 'content:encoded')
    rewritten_content = rewrite_image_urls(content)
    front_matter = build_front_matter(item, date_text)
    post_text = render_post(front_matter, rewritten_content)

    unless @dry_run
      File.write(output_path, post_text)
    end

    @stats[:written_posts] += 1
  end

  def build_front_matter(item, date_text)
    categories = []
    tags = []

    item.elements.each('category') do |cat|
      name = cat.text.to_s.strip
      next if name.empty?

      domain = cat.attributes['domain']
      if domain == 'post_tag'
        tags << name
      elsif domain == 'category'
        categories << name
      end
    end

    fm = {
      'layout' => 'post',
      'title' => text(item, 'title'),
      'date' => date_text
    }

    author = text(item, 'dc:creator')
    fm['author'] = author unless author.empty?
    fm['categories'] = categories.uniq unless categories.empty?
    fm['tags'] = tags.uniq unless tags.empty?
    fm
  end

  def render_post(front_matter, content)
    yaml = YAML.dump(front_matter)
    yaml = yaml.sub(/\A---\s*\n/, '')
    yaml = yaml.sub(/\.\.\.\s*\n?\z/, '')
    body = content.to_s
    body = "#{body}\n" unless body.end_with?("\n")
    "---\n#{yaml}---\n\n#{body}"
  end

  def rewrite_image_urls(content)
    content.to_s.gsub(URL_RE) do |matched_url|
      trailing_punctuation = matched_url[/[),.;:!?]+\z/] || ''
      core_url = trailing_punctuation.empty? ? matched_url : matched_url[0...-trailing_punctuation.length]

      replacement = rewrite_url(core_url)
      replacement ? "#{replacement}#{trailing_punctuation}" : matched_url
    end
  end

  def rewrite_url(url)
    parsed = safe_parse_uri(url)
    return nil unless parsed

    host = parsed[:host]
    path = parsed[:path]

    upload_path = nil
    if path =~ %r{/wp-content/uploads/(.+)\z}i
      upload_path = Regexp.last_match(1)
    elsif host&.include?('files.wordpress.com') && path =~ %r{/([0-9]{4}/[0-9]{2}/[^/]+)\z}
      upload_path = Regexp.last_match(1)
    elsif host&.end_with?('wordpress.com') && path =~ %r{/wp-content/uploads/(.+)\z}i
      upload_path = Regexp.last_match(1)
    end

    return nil unless upload_path

    local_rel_path = normalized_asset_relative_path(upload_path)
    return nil unless local_rel_path

    local_abs_path = File.expand_path(File.join(@site_root, local_rel_path))
    assets_root = File.expand_path(File.join(@site_root, 'assets', 'images'))
    return nil unless path_within_root?(local_abs_path, assets_root)

    unless File.file?(local_abs_path)
      @unmatched_image_urls[url] += 1
      return nil
    end

    @stats[:image_urls_rewritten] += 1
    "{{ '/#{local_rel_path.tr('\\', '/')}' | relative_url }}"
  end

  def safe_parse_uri(url)
    begin
      uri = URI.parse(url)
      return nil unless uri.host && uri.path

      { host: uri.host.downcase, path: uri.path }
    rescue URI::InvalidURIError
      begin
        encoded = url.encode('UTF-8').bytes.map { |b| b > 127 ? format('%%%02X', b) : b.chr }.join
        uri = URI.parse(encoded)
        return nil unless uri.host && uri.path

        { host: uri.host.downcase, path: CGI.unescape(uri.path) }
      rescue StandardError
        nil
      end
    end
  end

  def validate_xml_safety!(xml_text)
    if xml_text.match?(/<!DOCTYPE/i) || xml_text.match?(/<!ENTITY/i)
      abort('Unsafe XML detected: DOCTYPE/ENTITY is not allowed')
    end
  end

  def sanitize_slug(slug)
    value = slug.to_s.strip
    return '' if value.empty?

    sanitized = value.gsub(/[\\\/]+/, '-')
    sanitized = sanitized.gsub(/\.\.+/, '.')
    sanitized = sanitized.gsub(/[^\p{Alnum}%._-]+/u, '-')
    sanitized = sanitized.gsub(/-+/, '-')
    sanitized = sanitized.gsub(/^-+|-+$/, '')
    sanitized.downcase
  end

  def safe_post_output_path(filename)
    candidate = File.expand_path(File.join(@posts_dir, filename))
    return nil unless path_within_root?(candidate, @posts_dir)

    candidate
  end

  def normalized_asset_relative_path(upload_path)
    decoded_upload_path = CGI.unescape(upload_path.to_s)
    normalized = Pathname.new(decoded_upload_path).cleanpath.to_s.tr('\\', '/')
    return nil if normalized.start_with?('/')
    return nil if normalized == '..' || normalized.start_with?('../')
    return nil unless normalized.match?(%r{\A\d{4}/\d{2}/[^/]+\z})

    File.join('assets', 'images', normalized)
  end

  def path_within_root?(path, root)
    root_with_sep = root.end_with?(File::SEPARATOR) ? root : "#{root}#{File::SEPARATOR}"
    path == root || path.start_with?(root_with_sep)
  end

  def valid_date?(date_text)
    date_text.match?(/^\d{4}-\d{2}-\d{2}\s+\d{2}:\d{2}:\d{2}$/)
  end

  def slugify(text)
    slug = text.to_s.downcase.strip
    slug = slug.gsub(/[^\p{Alnum}]+/u, '-')
    slug = slug.gsub(/^-+|-+$/, '')
    slug.empty? ? 'untitled' : slug
  end

  def text(item, name)
    item.elements[name]&.text.to_s.strip
  end

  def print_report
    puts "XML: #{@xml_path}"
    puts "Posts dir: #{@posts_dir}"
    puts "Mode: #{@dry_run ? 'dry-run' : 'write'}"
    puts
    puts "total_items=#{@stats[:total_items]}"
    puts "selected_posts=#{@stats[:selected_posts]}"
    puts "written_posts=#{@stats[:written_posts]}"
    puts "skipped_collisions=#{@stats[:skipped_collisions]}"
    puts "image_urls_rewritten=#{@stats[:image_urls_rewritten]}"

    if @collisions.any?
      puts
      puts 'collisions:'
      @collisions.sort.each { |path| puts "- #{path}" }
    end

    if @unmatched_image_urls.any?
      puts
      puts 'unmatched_image_urls:'
      @unmatched_image_urls.sort_by { |url, count| [-count, url] }.each do |url, count|
        puts "- #{count}x #{url}"
      end
    end
  end
end

options = {
  site_root: Dir.pwd,
  xml: nil,
  posts_dir: '_posts',
  dry_run: false
}

parser = OptionParser.new do |opts|
  opts.banner = 'Usage: wordpress_to_jekyll.rb [options]'

  opts.on('--xml PATH', 'WordPress export XML path') { |v| options[:xml] = v }
  opts.on('--site-root PATH', 'Jekyll site root (default: cwd)') { |v| options[:site_root] = v }
  opts.on('--posts-dir PATH', 'Posts output dir relative to site root (default: _posts)') { |v| options[:posts_dir] = v }
  opts.on('--dry-run', 'Preview only, do not write files') { options[:dry_run] = true }
  opts.on('-h', '--help', 'Show help') do
    puts opts
    exit 0
  end
end

parser.parse!(ARGV)

if options[:xml].nil?
  imports = Dir.glob(File.join(options[:site_root], 'import', '*.xml')).sort
  options[:xml] = imports.last
end

abort('No XML path provided and no import/*.xml file found') if options[:xml].nil?

WordpressToJekyll.new(
  site_root: options[:site_root],
  xml_path: options[:xml],
  posts_dir: options[:posts_dir],
  dry_run: options[:dry_run]
).run
