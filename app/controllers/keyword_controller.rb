class KeywordController < ApplicationController
  def tokens
    render json: Keyword.find_keyword(params[:q])
  end

  def keyword_params
    params.require(:keyword).permit(:name)
  end

end
