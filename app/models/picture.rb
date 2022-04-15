class Picture < ApplicationRecord
  has_one_attached :file
  validates :file, presence: true, blob: { content_type: ['image/jpeg', 'image/jpg'] }

  belongs_to :album
end
