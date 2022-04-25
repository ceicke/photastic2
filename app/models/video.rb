class Video < ApplicationRecord
  validates :original_file, presence: true
  validates :album_id, presence: true

  has_one_attached :original_file
  has_one_attached :video_file
  has_one_attached :preview_image do |attachable|
    attachable.variant :thumb, resize_to_limit: [450, 450], auto_orient: true
  end

  enum :status, { queued: 0, transcoding: 1, transfering: 2, failed: 3, completed: 4 }

  belongs_to :album
  has_many :comments, as: :commentable, dependent: :destroy

  before_destroy :remove_files

  private
    def remove_files
      original_file.purge
      preview_image.purge
      video_file.purge
    end
end
