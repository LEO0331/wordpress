---
layout: page
title: Archive
permalink: /archive/
---

<ul class="post-list">
  {% for post in site.posts %}
    <li>
      <span class="post-meta">{{ post.date | date: "%Y-%m-%d" }}</span>
      <h2>
        <a class="post-link" href="{{ post.url | relative_url }}">{{ post.title }}</a>
      </h2>
    </li>
  {% endfor %}
</ul>
