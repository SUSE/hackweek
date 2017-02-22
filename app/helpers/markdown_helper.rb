module MarkdownHelper
  def self.render markdown_source
    Haml::Filters::Markdown.render markdown_source
  end
end
