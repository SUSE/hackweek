class AboutController < ApplicationController
  skip_before_filter :authenticate_user!, only: [ :show ]

  def index; end
  def show; end
end
