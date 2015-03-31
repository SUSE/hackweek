class GalleryController < ApplicationController
skip_before_filter :authenticate_user!, only: [ :index ]

  def index
    path = Rails.root.to_s + '/public/gallery/'
    full = Dir.entries(path)
    full.delete('.')
    full.delete('..')
    thumbs = Rails.root.to_s + '/public/gallery/.thumbnails/'
    display = Rails.root.to_s + '/public/gallery/.display/'
    @pictures = []
    full.each do |file|
      if File.file?(thumbs + file) && File.file?(display + file)
        @pictures << file
      end
    end
    @pictures.sort!.reverse!
  end
end
