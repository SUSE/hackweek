class MarkdownController < ApplicationController
  skip_before_filter :authenticate_user!, only: [:preview]
  respond_to :js

  def preview
    markdown_source = params[:source]
    @rendered = MarkdownHelper.render markdown_source
    respond_with @rendered
  end
end
