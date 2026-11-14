# frozen_string_literal: true
#
# jekyll-seo-tag and jekyll-feed run the site title through "smartify", which turns
# the straight apostrophe in "Hafiz's Security Journal" into a curly one (’) in the
# og:title / twitter:title / og:site_name meta tags, the JSON-LD and the Atom feed.
# This hook puts the straight apostrophe back, for the exact site title string only.

Jekyll::Hooks.register [:pages, :documents], :post_render do |doc|
  title = doc.site.config["title"].to_s
  next unless title.include?("'") && doc.output.is_a?(String)

  [
    title.tr("'", "\u2019"),       # ’
    title.gsub("'", "&rsquo;"),
    title.gsub("'", "&#8217;"),
    title.gsub("'", "&#x2019;"),
  ].each do |curly|
    doc.output = doc.output.gsub(curly, title) if doc.output.include?(curly)
  end
end
