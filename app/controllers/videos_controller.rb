class VideosController < ApplicationController
  before_action :set_video, only: %i[ show edit update destroy ]
  before_action :set_album
  before_action :check_permission, only: %i[ show edit update destroy ]
  before_action :check_album_user_permission, only: %i[ new create edit update destroy ]

  # GET /videos/1 or /videos/1.json
  def show
    @comment = Comment.new
  end

  # GET /videos/new
  def new
    @video = Video.new
  end

  # GET /videos/1/edit
  def edit
  end

  # POST /videos or /videos.json
  def create
    @video = Video.new(video_params)
    @video.album = @album

    respond_to do |format|
      if @video.save

        VideoTranscodingJob.perform_later(@video)

        format.html { redirect_to album_video_url(@album, @video), notice: "Video was successfully created." }
        format.json { render :show, status: :created, location: @video }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @video.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /videos/1 or /videos/1.json
  def update
    respond_to do |format|
      if @video.update(video_params)
        format.html { redirect_to album_video_url(@album, @video), notice: "Video was successfully updated." }
        format.json { render :show, status: :ok, location: @video }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @video.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /videos/1 or /videos/1.json
  def destroy
    @video.destroy

    respond_to do |format|
      format.html { redirect_to album_url(@album), notice: "Video was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_video
      @video = Video.find(params[:id])
    end

    def set_album
      @album = Album.find(params[:album_id])
    end

    def check_permission
      redirect_to root_path unless @album.is_owner_or_admin(current_user)
    end

    def check_album_user_permission
      redirect_to root_path if current_user.is_album_user?
    end

    # Only allow a list of trusted parameters through.
    def video_params
      params.require(:video).permit(:original_file, :description, :created_at)
    end
end
