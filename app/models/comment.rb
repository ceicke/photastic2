class Comment < ApplicationRecord
  validates :name, presence: true
  validates :comment, presence: true
  validates :picture_id, presence: true

  belongs_to :picture
end
