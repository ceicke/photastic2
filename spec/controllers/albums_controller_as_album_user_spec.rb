require 'rails_helper'

describe AlbumsController do

  before do
    @album = create(:album)
    allow(controller).to receive(:authenticate_user!).and_return(true)
    allow(controller).to receive(:current_user).and_return(UserAlbumAssociation.where(album_id: @album.id, album_user: true).first.user)
  end

  describe "for album users" do
    describe "show" do
      it "should redirect the user because they don't have access" do
        album = create(:album)
        get :show, params: {id: album.id}
        expect(subject).to redirect_to(root_path)
      end

      it "should work" do
        get :show, params: {id: @album.id}
        expect(assigns(:album)).to eq(@album)
      end
    end

    describe "#new" do
      it "should redirect to root_path" do
        get :new
        expect(subject).to redirect_to(root_path)
      end
    end

    describe "#edit" do
      it "should redirect to root_path" do
        get :edit, params: {id: @album.id}
        expect(subject).to redirect_to(root_path)
      end
    end
  end


end
