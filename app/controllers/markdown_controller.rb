class MarkdownController < ApplicationController
  def preview
    respond_to do |format|
      format.js do
        render
      end
    end
  end
end
