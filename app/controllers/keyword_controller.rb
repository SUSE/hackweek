class KeywordController < ApplicationController
  def tokens
    render json: Keyword.find_keyword(params[:q])
  end
end
