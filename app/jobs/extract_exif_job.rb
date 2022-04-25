class ExtractExifJob < ApplicationJob
  queue_as :default

  def perform(picture)
    path = Rails.root.join('tmp', SecureRandom.uuid.to_s)
    File.open(path, 'wb') do |file|
      file.write(picture.file.blob.download)
    end

    exif = Exiftool.new(path)
    data = exif.to_hash

    picture.update_attribute(:latitude, data[:gps_latitude]) unless data[:gps_latitude].blank?
    picture.update_attribute(:longitude, data[:gps_longitude]) unless data[:gps_longitude].blank?

    File.delete(path)
  end

end
