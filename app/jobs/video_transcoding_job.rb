class VideoTranscodingJob < ApplicationJob
  queue_as :default

  def perform(video)
    video.transcoding!

    Coconut.api_key = Rails.application.credentials.coconut[:api_key]

    if Rails.env.development?
      current_host = 'http://ceicke.duckdns.org'
    else
      current_host = 'https://www.photasti.cc'
    end

    notification = Coconut.notification = {
      type: "http",
      url: "#{current_host}/api/video_callback"
    }

    storage = Coconut.storage = {
      service: "s3",
      bucket: "photasti.cc",
      region: "eu-west-1",
      credentials: {
        access_key_id: Rails.application.credentials.aws[:access_key_id],
        secret_access_key: Rails.application.credentials.aws[:secret_access_key]
      }
    }

    original_file_url = ''
    ActiveStorage::Current.set(host: current_host) do
      original_file_url = video.original_file.url
    end

    job = Coconut::Job.create(
      input: {
        url: original_file_url
      },
      outputs: {
        "jpg:650x": {
          path: "photastic2/video_#{video.id}/preview.jpg"
        },
        "mp4:1080p": {
          path: "photastic2/video_#{video.id}/1080p.mp4"
        }
      }
    )

    video.update_attribute(:coconut_job_id, job.id)
  end
end
