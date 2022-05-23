require 'rails_helper'

describe CommentsController do

  before do
    @album = create(:album)
    allow(controller).to receive(:authenticate_user!).and_return(true)
    allow(controller).to receive(:current_user).and_return(UserAlbumAssociation.where(album_id: @album.id, album_user: true).first.user)
  end

  describe "#create" do
    it "should create a permanent cookie" do
      commenter_name = Faker::Name.first_name
      create(:picture, album: @album)

      expect {
        post :create, params: {
          album_id: @album.id,
          picture_id: @album.pictures.first.id,
          comment: {
            name: commenter_name,
            comment: Faker::Internet.password
          }
        }
      }.to change { cookies[:commenter_name] }.to commenter_name

    end
  end

end
