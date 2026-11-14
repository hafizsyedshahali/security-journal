---
title: Learning Path
icon: fas fa-route
order: 1
---

This journal follows my move from AI automation into cybersecurity, with the goal of becoming a SOC Engineer. Every post is written from my own study notes.

If you're new here, start with the first post and follow the series in order. Each one builds on the one before it.

{% assign series = "Getting Started|Networking|Cloud|Introduction to Cybersecurity|Endpoint Security|Network Defense|Cyber Threat Management|Projects" | split: "|" %}

{% for s in series %}
{% assign series_posts = site.categories[s] | sort: "date" %}
{% if series_posts.size > 0 %}
<h2 id="{{ s | slugify }}">{{ s }}</h2>
{% case s %}
{% when "Getting Started" %}<p>Why I started this journal, and where it's going.</p>
{% when "Networking" %}<p>The foundation: how networks work, from cables and switches to subnetting, routing and the core protocols.</p>
{% when "Cloud" %}<p>Cloud basics through AWS, with a focus on the parts that matter for security.</p>
{% when "Introduction to Cybersecurity" %}<p>Cisco's Introduction to Cybersecurity: data, privacy, attackers and common attacks.</p>
{% when "Endpoint Security" %}<p>Cisco's Endpoint Security: threats, attacks on networks and applications, network defenses, and securing Windows and Linux.</p>
{% when "Network Defense" %}<p>Cisco's Network Defense: defense in depth, access control, ACLs, firewalls, cloud security, cryptography and security monitoring.</p>
{% when "Cyber Threat Management" %}<p>Cisco's Cyber Threat Management: governance, frameworks, vulnerability assessment, risk, forensics and incident response.</p>
{% when "Projects" %}<p>Hands-on work: tools, labs and security automation.</p>
{% endcase %}
<ol>
{% for p in series_posts %}
  <li><a href="{{ p.url | relative_url }}">{{ p.title }}</a> <small>({{ p.date | date: "%b %-d, %Y" }})</small></li>
{% endfor %}
</ol>
{% endif %}
{% endfor %}
