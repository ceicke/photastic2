class ApiController < ApplicationController
  skip_before_action :verify_authenticity_token, :authenticate_user!

  def video_callback
    video = Video.find_by(coconut_job_id: params['job_id'])

    unless video.nil?
      if params['event'] == 'job.failed'
        video.failed!
      elsif params['event'] == 'job.completed'
        VideoTransferJob.perform_later(video)
      end
    end

    head :ok
  end

end
