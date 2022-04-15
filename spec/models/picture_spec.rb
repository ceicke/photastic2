require 'rails_helper'

RSpec.describe Picture, type: :model do
  it 'is valid with valid attributes' do
    picture = build(:picture)
    expect(picture).to be_valid
  end

  it 'is not valid without a file' do
    picture = build(:picture, file: nil)
    expect(picture).to_not be_valid
  end

end
