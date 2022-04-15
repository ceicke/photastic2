class Album < ApplicationRecord
  validates :name, presence: true
  validates :passcode, presence: true

  has_many :pictures, dependent: :destroy

  def subdomain
    name.parameterize(separator: '_')
  end
end
