class Album < ApplicationRecord
  validates :name, presence: true
  validates :passcode, presence: true

  has_many :pictures, dependent: :destroy
  has_many :videos, dependent: :destroy

  def stream
    all_elements = pictures + videos
    all_elements.sort { |a,b| b.created_at <=> a.created_at }
  end

  def subdomain
    name.parameterize(separator: '_')
  end

end
