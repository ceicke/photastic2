require 'rails_helper'

describe VideosController do

  before do
    @user = create(:user)
    allow(controller).to receive(:authenticate_user!).and_return(true)
    allow(controller).to receive(:current_user).and_return(@user)
  end

  describe "#create" do
    it "the job for transcoding the video is enqueed" do
      ActiveJob::Base.queue_adapter = :test

      album = create(:album)
      video = build(:video, album: album)

      expect {
        post :create, params: {
          album_id: album.id,
          video: {
            description: video.description,
            original_file: Rack::Test::UploadedFile.new(Rails.root.join('spec','support', 'test.mp4'), 'movie/mp4')
          }
        }
      }.to have_enqueued_job(VideoTranscodingJob)

    end

    it "redirects to the video" do
      album = create(:album)
      video = build(:video, album: album)

      post :create, params: {
        album_id: album.id,
        video: {
          description: video.description,
          original_file: Rack::Test::UploadedFile.new(Rails.root.join('spec','support', 'test.mp4'), 'movie/mp4')
        }
      }
      expect(response).to redirect_to "/albums/#{album.id}/videos/1"
    end
  end

  describe "show" do
    it "should show only a video that the user has access to" do
      album = create(:album)
      album.users << @user
      video = create(:video, album: album)
      get :show, params: {album_id: album.id, id: video.id}
      expect(assigns(:video)).to eq(video)
    end

    it "should redirect the user if they don't have access" do
      video = create(:video)
      get :show, params: {album_id: video.album.id, id: video.id}
      expect(subject).to redirect_to(root_path)
    end
  end

end
