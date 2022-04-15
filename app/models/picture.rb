class Picture < ApplicationRecord
  has_one_attached :file
  validates :file, presence: true, blob: { content_type: ['image/jpeg', 'image/jpg'] }
  validates :album_id, presence: true

  belongs_to :album
  has_many :comments
end
