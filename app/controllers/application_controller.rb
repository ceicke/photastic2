class ApplicationController < ActionController::Base
  before_action :cookie_authenticated?
  before_action :check_subdomain

  def bla
    if request_with_subdomain?
      if cookie_authenticated?
        # redirect to album
        album = Album.find_by(subdomain: request.subdomains.first)
        redirect_to album_path(album)
      else
        # redirect to album authentication
        album = Album.find_by(subdomain: request.subdomains.first)
        redirect_to new_album_authenticate_path(album_id: album)
      end
    else
      # require authentication user
      authenticate_user!
    end
  end

  def request_with_subdomain?
    request.subdomains.any?
  end

  def cookie_authenticated?
    p cookies.encrypted[:album_id]
    p cookies.encrypted[:album_passcode]
    p cookies.encrypted[:name]
    if cookies.encrypted[:album_id].present?
      @cookie_authenticated = true
      p "cookie authenticated"
    else
      @cookie_authenticated = false
      p "cookie not authenticated"
    end
  end

  private
  def check_subdomain

    p 'checking subdomain'

    # if we have any subdomains, then we check for subdomain access
    if request.subdomains.any?

      p 'found subdomain'

      album = Album.find_by(subdomain: request.subdomains.first)

      if check_cookie_auth
        redirect_to album_path(album)
      else
        redirect_to new_album_authenticate_path(album_id: album)
      end

    else
      # here we have no subdomain and are in the admin area
      authenticate_user!
    end

  end

  def check_cookie_auth
    if cookies.encrypted[:album_id].present?
      album = Album.find_by(subdomain: request.subdomains.first)
      if cookies.encrypted[:album_passcode] == album.passcode
        p 'true'
        return true
      else
        p 'false 1'
        return false
      end
    else
      p 'false 2'
      return false
    end
  end
end
