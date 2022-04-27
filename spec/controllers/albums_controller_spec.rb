require 'rails_helper'

describe AlbumsController do

  before do
    @user = create(:user)
    allow(controller).to receive(:authenticate_user!).and_return(true)
    allow(controller).to receive(:current_user).and_return(@user)
  end

  describe "#index" do
    it "should remove the 'page' cookie" do
      cookies[:page] = Faker::Number.digit
      get :index
      expect(cookies[:page]).to eq nil
    end

    it "should only deliver the albums that the user can see" do
      album_1 = create(:album)
      album_2 = create(:album)
      album_2.users << @user
      get :index
      expect(assigns(:albums)).to eq([album_2])
    end

    it "should deliver all albums when being an admin user" do
      @user = create(:user, admin: true)
      allow(controller).to receive(:authenticate_user!).and_return(true)
      allow(controller).to receive(:current_user).and_return(@user)

      album_1 = create(:album)
      album_2 = create(:album)
      album_2.users << @user
      get :index
      expect(assigns(:albums)).to eq([album_1,  album_2])
    end
  end

  describe "show" do
    it "should set the 'page' cookie" do
      album = create(:album)
      album.users << @user
      get :show, params: {id: album.id, page: 5}
      expect(cookies[:page]).to eq '5'
    end

    it "should show only an album that the user has access to" do
      album = create(:album)
      album.users << @user
      get :show, params: {id: album.id}
      expect(assigns(:album)).to eq(album)
    end

    it "should redirect the user if they don't have access" do
      album = create(:album)
      get :show, params: {id: album.id}
      expect(subject).to redirect_to(root_path)
    end
  end

end
