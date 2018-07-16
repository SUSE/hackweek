class MarkdownController < ApplicationController
  skip_before_action :authenticate_user!, only: [:preview]
  respond_to :js

  def preview
    markdown_source = params[:source].to_str.gsub(/:([\w+-]+):/) do |match|
                        %(![add-emoji](https://assets-cdn.github.com/images/icons/emoji/#{match.to_str.tr(':','')}.png))
                      end if params[:source]
    @rendered = MarkdownHelper.render markdown_source
    respond_with @rendered
  end
end
