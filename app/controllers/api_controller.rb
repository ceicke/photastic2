class ApiController < ApplicationController
  skip_before_action :verify_authenticity_token, :authenticate_user!, :check_subdomain
  before_action :authenticate_user!, only: [ :favorites ]

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

  def favorites
    picture = Picture.where(favorite: true).order(Arel.sql('RANDOM()')).first
    if Rails.env.development?
      ActiveStorage::Current.url_options = { host: 'http://localhost:3000' }
    end

    picture_hash = {
      url: picture.file.url,
      description: picture.description,
      created_at: picture.created_at
    }

    respond_to do |format|
      format.json { render json: picture_hash.to_json }
    end
  end

end
