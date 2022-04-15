class ApiController < ApplicationController
  skip_before_action :verify_authenticity_token

  def video_callback
    unless params['event'] == 'job.failed'
      video = Video.where(coconut_job_id: params['job_id']).first
      video.transfer_transcoded_files
      video.update_attribute(:processed, true)
    end

    head :ok
  end

end
