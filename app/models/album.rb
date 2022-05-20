class Album < ApplicationRecord
  validates :name, presence: true
  validates :passcode, presence: true

  has_many :pictures, dependent: :destroy
  has_many :videos, dependent: :destroy

  has_many :user_album_associations
  has_many :users, through: :user_album_associations

  after_create :set_subdomain

  def stream
    all_elements = pictures + videos
    all_elements.sort { |a,b| b.created_at <=> a.created_at }
  end

  def is_owner_or_admin(user)
    user.admin? || users.include?(user)
  end

  private
    def set_subdomain
      update_attribute(:subdomain, name.parameterize(separator: '_'))
    end

end
