class Picture < ApplicationRecord
  validates :file, presence: true, blob: { content_type: ['image/jpeg', 'image/jpg'] }
  validates :album_id, presence: true

  has_one_attached :file do |attachable|
    attachable.variant :thumb, resize_to_limit: [450, 450], autorot: true, rot180: true
    attachable.variant :large, resize_to_limit: [1400, 1400], autorot: true, rot180: true
  end

  belongs_to :album
  has_many :comments, as: :commentable, dependent: :destroy

  before_destroy :remove_file

  private
    def remove_file
      file.purge
    end

end
