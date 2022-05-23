class AlbumsController < ApplicationController
  before_action :set_album, only: %i[ show edit update destroy ]
  before_action :check_permission, only: %i[ show edit update destroy ]
  before_action :check_album_user_permission, only: %i[ new create edit update destroy ]

  # GET /albums or /albums.json
  def index
    cookies.delete :page
    if current_user.admin?
      @albums = Album.where(hidden: false)
    else
      @albums = Album.includes(:user_album_associations).where("user_album_associations.user_id": current_user.id, hidden: false)
    end
  end

  # GET /albums/1 or /albums/1.json
  def show
    if @album.hidden?
      redirect_to root_path, notice: "Album is slated to be removed"
    end

    @elements = Kaminari.paginate_array(@album.stream).page(set_page).per(50)
  end

  # GET /albums/new
  def new
    @album = Album.new
  end

  # GET /albums/1/edit
  def edit
  end

  # POST /albums or /albums.json
  def create
    @album = Album.new(album_params)

    respond_to do |format|
      if @album.save
        @album.users << current_user
        format.html { redirect_to album_url(@album), notice: "Album was successfully created." }
        format.json { render :show, status: :created, location: @album }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @album.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /albums/1 or /albums/1.json
  def update
    respond_to do |format|
      if @album.update(album_params)
        format.html { redirect_to album_url(@album), notice: "Album was successfully updated." }
        format.json { render :show, status: :ok, location: @album }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @album.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /albums/1 or /albums/1.json
  def destroy
    @album.update_attribute(:hidden, true)
    DeleteAlbumJob.perform_later(@album)

    respond_to do |format|
      format.html { redirect_to root_path, notice: "Album was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_album
      @album = Album.find(params[:id])
    end

    def check_permission
      redirect_to root_path unless @album.is_owner_or_admin(current_user)
    end

    def check_album_user_permission
      redirect_to root_path if current_user.is_album_user?
    end

    # Only allow a list of trusted parameters through.
    def album_params
      params.require(:album).permit(:name, :passcode)
    end

    def set_page
      if !params[:page].blank?
        cookies[:page] = params[:page]
        return params[:page]
      else
        if !cookies[:page].blank?
          return cookies[:page]
        else
          return 1
        end
      end
    end
end
