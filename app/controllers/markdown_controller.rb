class MarkdownController < ApplicationController
  skip_before_filter :authenticate_user!, only: [:preview]
  respond_to :js
  include ApplicationHelper

  def preview
    markdown_source = emojify params[:source]
    @rendered = MarkdownHelper.render markdown_source
    respond_with @rendered
  end
end
