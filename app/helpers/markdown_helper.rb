module MarkdownHelper
  def self.render(markdown_source)
    Haml::Filters::Markdown.render markdown_source
  end

  def mdpreview(markdown_source, lines: 3)
    markdown_source.lines.reject { |l| l =~ /\[comment\]/ }.select { |l| l =~ /\S/ }[0..lines-1].join
  end
end
