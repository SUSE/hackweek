module Haml::Filters
  remove_filter("Markdown") #remove the existing Markdown filter

  module Markdown
    include Haml::Filters::Base

    def render(text)
      Redcarpet::Markdown.new(
        Redcarpet::Render::HTML.new(escape_html: true)
      ).render(text)
    end
  end
end
