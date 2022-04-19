require 'rails_helper'

RSpec.describe VideoTranscodingJob, type: :job do
  describe "#perform_later" do
    it "updates the status of the video" do
      ActiveJob::Base.queue_adapter = :test
      video = create(:video)

      VideoTranscodingJob.perform_now(video)

      expect(video.transcoding?).to be(true)
    end
  end
end
