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

  it 'generates a list of elements' do
    album = create(:album)

    2.times do
      create(:picture, album: album)
    end
    2.times do
      create(:video, album: album)
    end

    expect(album.stream.length).to eq(4)
  end

  it 'orders the elements by created_at with newest on top' do
    album = create(:album)

    create(:picture, album: album, created_at: Date.yesterday)
    create(:video, album: album, created_at: Date.tomorrow)

    expect(album.stream.first.created_at).to eq(Date.tomorrow)
    expect(album.stream.last.created_at).to eq(Date.yesterday)
  end

  it 'generates a correct subdomain' do
    album = build(:album, name: 'Some test')
    expect(album.subdomain).to eq('some_test')
  end
end
