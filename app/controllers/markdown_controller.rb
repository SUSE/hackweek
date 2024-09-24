class MarkdownController < ApplicationController
  def preview
    @markdown_source = helpers.enrich_markdown(markdown: params[:source])
  end
end
