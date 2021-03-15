class AboutController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[show index]

  def index
    return unless @episode

    @popular_keywords = Keyword.popular(@episode, 10).sample(3)
    @popular_projects = Project.current(@episode).order('projecthits DESC').first(6)
  end

  def show; end
end
