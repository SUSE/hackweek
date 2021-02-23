class MarkdownController < ApplicationController
  skip_before_action :authenticate_user!, only: [:preview]
  respond_to :js

  def preview
    if params[:source]
      markdown_source = params[:source].to_str.gsub(/(?<=^|\s):([\w+-]+):(?=\s|$)/) do |match|
        %(![add-emoji](https://github.githubassets.com/images/icons/emoji/#{match.to_str.tr(':', '')}.png))
      end
    end
    @rendered = MarkdownHelper.render markdown_source
    respond_with @rendered
  end
end
