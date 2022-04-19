require 'rails_helper'

RSpec.describe VideoTransferJob, type: :job do
  describe "#perform_later" do
    it "updates the status of the video" do
      ActiveJob::Base.queue_adapter = :test
      video = create(:video)

      VideoTransferJob.perform_now(video)

      expect(video.completed?).to be(true)
    end
  end
end
