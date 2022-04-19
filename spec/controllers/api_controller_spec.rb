require 'rails_helper'

describe ApiController do

  describe "#video_callback" do
    it "the job for transfering the video is enqueed" do
      ActiveJob::Base.queue_adapter = :test

      album = create(:album)
      video = create(:video, album: album, coconut_job_id: 'coconut123')

      expect {
        post :video_callback, params: {
          event: 'job.completed',
          job_id: 'coconut123'
        }
      }.to have_enqueued_job(VideoTransferJob)

    end
  end

end
