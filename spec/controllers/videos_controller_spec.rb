require 'rails_helper'

describe VideosController do

  describe "#create" do
    it "the job for transcoding the video is enqueed" do
      ActiveJob::Base.queue_adapter = :test

      album = create(:album)
      video = build(:video, album: video)

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

end
