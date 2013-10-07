class GalleryController < ApplicationController

skip_before_filter :authenticate_user!, :only => [ :index ]

  def index
    path = Rails.root.to_s + '/public/gallery/'
    full = Dir.entries(path)
    full.delete(".")
    full.delete("..")
    thumbs = Rails.root.to_s + '/public/gallery/.thumbnails/'
    @pictures = []
    full.each do |file|
      @pictures << file if File.file?(thumbs + file)
    end
  end

end
