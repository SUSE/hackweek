module MarkdownHelper
  def self.render markdown_source
    renderer = Redcarpet::Render::HTML.new
    markdown = Redcarpet::Markdown.new(renderer)

    markdown.render markdown_source
  end
end
