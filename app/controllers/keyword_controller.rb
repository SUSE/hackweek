class KeywordController < ApplicationController
  def tokens
    render json: {:keywords => Keyword.find_keyword(params[:q]) }
  end
end
