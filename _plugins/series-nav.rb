# frozen_string_literal: true
#
# Adds _includes/series-nav.html to the top and bottom of every post listed in _data/series.yml,
# without editing the posts or copying Chirpy's post layout. The include is rendered by Liquid
# together with the post, before Markdown conversion.

Jekyll::Hooks.register :posts, :pre_render do |post|
  series = post.site.data["series"] || []
  slug = post.data["slug"]
  next unless series.any? { |s| Array(s["posts"]).include?(slug) }

  post.content = "{% include series-nav.html position=\"top\" %}\n\n" \
                 "#{post.content}\n\n" \
                 "{% include series-nav.html position=\"bottom\" %}\n"
end
