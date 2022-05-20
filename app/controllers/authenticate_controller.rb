class AuthenticateController < ApplicationController
  skip_before_action :check_subdomain

  def new
    @album = Album.find(params[:album_id])
  end

  def create
    @album = Album.find(params[:album_id])

    if params[:passcode] == @album.passcode
      sign_in(User.create(name: params[:name]))
      cookies.encrypted[:album_passcode] = params[:passcode]
      cookies.encrypted[:album_id] = @album.id
      cookies.encrypted[:name] = params[:name]

      redirect_to album_path(@album)
    else
      format.html { render :new, status: :unprocessable_entity }
    end
  end

end
