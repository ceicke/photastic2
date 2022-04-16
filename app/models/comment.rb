class Comment < ApplicationRecord
  validates :name, presence: true
  validates :comment, presence: true

  belongs_to :commentable, polymorphic: true
end
