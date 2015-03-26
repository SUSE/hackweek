class MarkdownController < ApplicationController
  respond_to :js

  def preview
    @text = 'Hello!'
    respond_with @text
  end
end
