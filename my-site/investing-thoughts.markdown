---
layout: page
title: 投資思考專欄
permalink: /investing-thoughts/
---

<div class="category-page">
  <header class="category-header">
    <h2>投資思考專欄</h2>
    <p>收錄「投資思考」系列文章與相關投資觀點。</p>
  </header>

  <ul class="category-posts investing-series-list">
    {% assign investing_posts = site.posts | where_exp: "post", "post.title contains '投資思考'" %}
    {% if investing_posts.size > 0 %}
      {% for post in investing_posts %}
        {% assign title_parts = post.title | split: ' ' %}
        {% assign issue_no = title_parts | last | plus: 0 %}
        {% assign newer_index = forloop.index0 | minus: 1 %}
        {% assign older_index = forloop.index0 | plus: 1 %}
        {% assign newer_post = nil %}
        {% assign older_post = nil %}
        {% if newer_index >= 0 %}
          {% assign newer_post = investing_posts[newer_index] %}
        {% endif %}
        {% if older_index < investing_posts.size %}
          {% assign older_post = investing_posts[older_index] %}
        {% endif %}
        <li>
          <p class="meta">{{ post.date | date: "%Y-%m-%d" }}</p>
          <h2>
            <a href="{{ post.url | relative_url }}">{{ post.title }}</a>
          </h2>
          {% if issue_no > 0 %}
            <p class="series-badge">第 {{ issue_no }} 篇</p>
          {% endif %}
          <p>{{ post.excerpt | strip_html | normalize_whitespace | truncate: 170 }}</p>

          <div class="series-nav">
            {% if older_post %}
              <a class="series-nav-btn" href="{{ older_post.url | relative_url }}">上一期</a>
            {% else %}
              <span class="series-nav-btn is-disabled">上一期</span>
            {% endif %}

            {% if newer_post %}
              <a class="series-nav-btn" href="{{ newer_post.url | relative_url }}">下一期</a>
            {% else %}
              <span class="series-nav-btn is-disabled">下一期</span>
            {% endif %}
          </div>
        </li>
      {% endfor %}

    {% else %}
      <li>
        <p>目前尚無投資思考系列文章。</p>
      </li>
    {% endif %}
  </ul>
</div>
