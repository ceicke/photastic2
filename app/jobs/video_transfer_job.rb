class VideoTransferJob < ApplicationJob
  queue_as :default

  def perform(video)
    logger.info "Transfering Video #{video.id}"
    video.transfering!

    s3_client = Aws::S3::Client.new({
      region: 'eu-west-1',
      access_key_id: Rails.application.credentials.aws[:access_key_id],
      secret_access_key: Rails.application.credentials.aws[:secret_access_key]
    })

    transfer_video_file(s3_client, video)
    transfer_preview_file(s3_client, video)

    video.completed!
  end

  private
    def transfer_video_file(s3_client, video)
      logger.info "Transfering video file."
      s3_client.get_object({bucket: 'photasti.cc', key: "photastic2/video_#{video.id}/1080p.mp4"}, target: "tmp/#{video.id}-1080p.mp4")
      video.video_file.attach(io: File.open("tmp/#{video.id}-1080p.mp4"), filename: '1080p.mp4')

      s3_client.delete_object(bucket: 'photasti.cc', key: "photastic2/video_#{video.id}/1080p.mp4")
      File.delete("tmp/#{video.id}-1080p.mp4")
    end

    def transfer_preview_file(s3_client, video)
      logger.info "Transfering preview file."
      s3_client.get_object({bucket: 'photasti.cc', key: "photastic2/video_#{video.id}/preview.jpg"}, target: "tmp/#{video.id}-preview.jpg")
      video.preview_image.attach(io: File.open("tmp/#{video.id}-preview.jpg"), filename: 'preview.jpg')

      s3_client.delete_object(bucket: 'photasti.cc', key: "photastic2/video_#{video.id}/preview.jpg")
      File.delete("tmp/#{video.id}-preview.jpg")
    end
end
