require 'rails_helper'

RSpec.describe Album, type: :model do
  it 'is valid with valid attributes' do
    album = build(:album)
    expect(album).to be_valid
  end

  it 'is not valid without an album name' do
    album = build(:album, name: nil)
    expect(album).to_not be_valid
  end

  it 'is not valid without a passcode' do
    album = build(:album, passcode: nil)
    expect(album).to_not be_valid
  end

  it 'generates a correct subdomain' do
    album = build(:album, name: 'Some test')
    expect(album.subdomain).to eq('some_test')
  end
end
