#!/usr/bin/env ruby
# frozen_string_literal: true

require 'yaml'
require 'fileutils'
require 'pathname'
require 'date'

SITE_ROOT = File.expand_path('..', __dir__)
POSTS_DIR = File.join(SITE_ROOT, '_posts')
CATEGORY_DIR = File.join(SITE_ROOT, 'category')
CATEGORIES_INDEX = File.join(SITE_ROOT, 'categories.markdown')

def parse_front_matter(path)
  text = File.read(path)
  fm = text[/\A---\n(.*?)\n---\n/m, 1]
  return {} unless fm

  YAML.safe_load(fm, permitted_classes: [Time, Date], aliases: true) || {}
rescue StandardError
  {}
end

def base_slug(value)
  slug = value.to_s.downcase.strip
  slug = slug.gsub(/[\s\/]+/, '-')
  slug = slug.gsub(/[^\p{Alnum}\p{Han}\p{Hiragana}\p{Katakana}\p{Hangul}-]+/u, '')
  slug = slug.gsub(/-+/, '-')
  slug = slug.gsub(/^-+|-+$/, '')
  slug.empty? ? 'category' : slug
end

def unique_slug(base, used)
  return base unless used.key?(base)

  n = 2
  loop do
    candidate = "#{base}-#{n}"
    return candidate unless used.key?(candidate)

    n += 1
  end
end

category_counts = Hash.new(0)
Dir.glob(File.join(POSTS_DIR, '*.{md,markdown}')).each do |path|
  fm = parse_front_matter(path)
  Array(fm['categories']).each do |category|
    key = category.to_s.strip
    next if key.empty?

    category_counts[key] += 1
  end
end

sorted = category_counts.sort_by { |name, count| [-count, name] }

FileUtils.mkdir_p(CATEGORY_DIR)

used_slugs = {}
slug_map = {}

sorted.each do |name, count|
  slug = unique_slug(base_slug(name), used_slugs)
  used_slugs[slug] = true
  slug_map[name] = slug

  path = File.join(CATEGORY_DIR, "#{slug}.markdown")
  content = <<~MD
    ---
    layout: category
    title: "#{name}"
    permalink: /category/#{slug}/
    category_name: "#{name}"
    ---
  MD

  File.write(path, content)
end

index = <<~MD
  ---
  layout: page
  title: Categories
  permalink: /categories/
  ---

  <ul class="category-index-list">
  #{sorted.map { |name, count| "  <li><a href=\"{{ '/category/#{slug_map[name]}/' | relative_url }}\">#{name}</a> <span>(#{count})</span></li>" }.join("\n")}
  </ul>
MD

File.write(CATEGORIES_INDEX, index)

puts "Generated #{sorted.size} category pages in #{Pathname.new(CATEGORY_DIR).relative_path_from(Pathname.new(SITE_ROOT))}"
puts "Updated #{Pathname.new(CATEGORIES_INDEX).relative_path_from(Pathname.new(SITE_ROOT))}"
