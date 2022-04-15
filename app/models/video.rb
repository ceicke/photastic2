class Video < ApplicationRecord
  validates :original_file, presence: true
  validates :album_id, presence: true

  has_one_attached :original_file
  has_one_attached :video_file
  has_one_attached :preview_image do |attachable|
    attachable.variant :thumb, resize_to_limit: [450, 450]
  end

  belongs_to :album
  # has_many :comments, dependent: :destroy

  before_destroy :remove_files

  def coconut_failed?
    return get_coconut_status.status == 'job.failed'
  end

  def transcode
    Coconut.api_key = Rails.application.credentials.coconut[:api_key]

    if Rails.env.development?
      current_host = 'http://ceicke.duckdns.org'
    else
      current_host = 'https://photasti.cc'
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
      original_file_url = original_file.url
    end

    job = Coconut::Job.create(
      input: {
        url: original_file_url
      },
      outputs: {
        "jpg:650x": {
          path: "photastic2/video_#{id}/preview.jpg"
        },
        "mp4:1080p": {
          path: "photastic2/video_#{id}/1080p.mp4"
        }
      }
    )

    update_attribute(:coconut_job_id, job.id)

  end



  def transfer_transcoded_files
    s3 = Aws::S3::Client.new({
      region: 'eu-west-1',
      access_key_id: Rails.application.credentials.aws[:access_key_id],
      secret_access_key: Rails.application.credentials.aws[:secret_access_key]
    })

    s3.get_object({bucket: 'photasti.cc', key: "photastic2/video_#{id}/1080p.mp4"}, target: 'tmp/1080p.mp4')
    s3.get_object({bucket: 'photasti.cc', key: "photastic2/video_#{id}/preview.jpg"}, target: 'tmp/preview.jpg')

    video_file.attach(io: File.open('tmp/1080p.mp4'), filename: '1080p.mp4')
    preview_image.attach(io: File.open('tmp/preview.jpg'), filename: 'preview.jpg')

    s3.delete_object(bucket: 'photasti.cc', key: "photastic2/video_#{id}/1080p.mp4")
    s3.delete_object(bucket: 'photasti.cc', key: "photastic2/video_#{id}/preview.jpg")

    File.delete('tmp/1080p.mp4')
    File.delete('tmp/preview.jpg')
  end

  private
    def get_coconut_status
      Coconut.api_key = Rails.application.credentials.coconut[:api_key]

      if coconut_job_id.nil?
        return nil
      else
        Coconut::Job.retrieve(coconut_job_id)
      end
    end

    def remove_files
      original_file.purge
      preview_image.purge
      video_file.purge
    end
end
