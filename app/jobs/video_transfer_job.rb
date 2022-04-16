class VideoTransferJob < ApplicationJob
  queue_as :default

  def perform(video)
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
      s3_client.get_object({bucket: 'photasti.cc', key: "photastic2/video_#{video.id}/1080p.mp4"}, target: 'tmp/1080p.mp4')
      video.video_file.attach(io: File.open('tmp/1080p.mp4'), filename: '1080p.mp4')

      s3_client.delete_object(bucket: 'photasti.cc', key: "photastic2/video_#{video.id}/1080p.mp4")
      File.delete('tmp/1080p.mp4')
    end

    def transfer_preview_file(s3_client, video)
      s3_client.get_object({bucket: 'photasti.cc', key: "photastic2/video_#{video.id}/preview.jpg"}, target: 'tmp/preview.jpg')
      video.preview_image.attach(io: File.open('tmp/preview.jpg'), filename: 'preview.jpg')

      s3_client.delete_object(bucket: 'photasti.cc', key: "photastic2/video_#{video.id}/preview.jpg")
      File.delete('tmp/preview.jpg')
    end
end
