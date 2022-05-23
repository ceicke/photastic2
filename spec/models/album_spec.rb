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

  it 'creates an album user' do
    album = create(:album)
    expect(UserAlbumAssociation.where(album_id: album.id, album_user: true).length).to eq(1)
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

    expect(album.stream.first.created_at.to_date).to eq(Date.tomorrow)
    expect(album.stream.last.created_at.to_date).to eq(Date.yesterday)
  end

  it 'generates a correct subdomain' do
    album = create(:album, name: 'Some test')
    expect(album.subdomain).to eq('some_test')
  end

  it 'should default to "visible"' do
    album = create(:album)
    expect(album.hidden?).to be(false)
  end

  describe 'album permission checking' do
    it 'should validate album owners' do
      album = create(:album)
      user = album.users.first
      expect(album.is_owner_or_admin(user)).to be(true)
    end

    it 'should validate admin users' do
      album = create(:album)
      admin = create(:user, admin: true)
      expect(album.is_owner_or_admin(admin)).to be(true)
    end

    it 'should not validate non owners' do
      album = create(:album)
      user = create(:user)
      expect(album.is_owner_or_admin(user)).to be(false)
    end
  end
end
