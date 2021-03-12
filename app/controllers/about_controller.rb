class AboutController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[show index]

  def index
    return unless @episode

    @keywords = Keyword.by_episode(@episode).order(:name).uniq.first(5)
    @popular_keywords = Keyword.by_episode(@episode)
                               .group(:name).count
                               .sort_by { |_name, occurance| occurance }.reverse
                               .first(10).map { |keyword| Keyword.find_by(name: keyword[0]) }
  end

  def show; end
end
