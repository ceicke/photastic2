class CommentsController < ApplicationController
  before_action :set_comment, only: %i[ destroy ]
  before_action :set_album_and_picture_or_video
  before_action :check_permission, only: %i[ destroy ]
  before_action :check_album_user_permission, only: %i[ destroy ]

  # POST /comments or /comments.json
  def create
    @comment = Comment.new(comment_params)
    @comment.commentable = @element

    respond_to do |format|
      if @comment.save

        cookies.permanent[:commenter_name] = @comment.name

        format.html {
          if @element.is_a? Picture
            redirect_to album_url(@album, page: cookies[:page], anchor: "picture_#{@element.id}"), notice: "Comment was successfully created."
          elsif @element.is_a? Video
            redirect_to album_url(@album, page: cookies[:page], anchor: "video_#{@element.id}"), notice: "Comment was successfully created."
          end
        }
        format.json { render :show, status: :created, location: @comment }
      else
        format.html { redirect_to album_picture_url(@album, @element), status: :unprocessable_entity }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1 or /comments/1.json
  def destroy
    @comment.destroy

    respond_to do |format|
      format.html {
        if @element.is_a? Picture
          redirect_to album_url(@album, page: cookies[:page], anchor: "picture_#{@element.id}"), notice: "Comment was successfully destroyed."
        elsif @element.is_a? Video
          redirect_to album_url(@album, page: cookies[:page], anchor: "video_#{@element.id}"), notice: "Comment was successfully destroyed."
        end
      }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params[:id])
    end

    def check_permission
      redirect_to root_path unless @album.is_owner_or_admin(current_user)
    end

    def check_album_user_permission
      redirect_to root_path if current_user.is_album_user?
    end

    def set_album_and_picture_or_video
      @album = Album.find(params[:album_id])
      unless params[:picture_id].blank?
        @element = Picture.find(params[:picture_id])
      end
      unless params[:video_id].blank?
        @element = Video.find(params[:video_id])
      end
    end

    # Only allow a list of trusted parameters through.
    def comment_params
      params.require(:comment).permit(:name, :comment)
    end
end
