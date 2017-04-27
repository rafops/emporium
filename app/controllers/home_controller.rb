class HomeController < ApplicationController
  def index
    @photos_low_res = Photo.where.not(parent_uuid: nil)
  end
end
