class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :check_subdomain

  def request_with_subdomain?
    request.subdomains.any?
  end

  private
    def check_subdomain
      if request.subdomains.present? && request.original_fullpath == '/'
        album = Album.find_by(subdomain: request.subdomains.first)
        redirect_to album_path(album) unless album.blank?
      end
    end

end
