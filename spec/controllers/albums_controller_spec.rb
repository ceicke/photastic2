require 'rails_helper'

describe AlbumsController do

  describe "#index" do
    it "should remove the 'page' cookie" do
      cookies[:page] = Faker::Number.digit
      get :index
      expect(cookies[:page]).to eq nil
    end
  end

  describe "show" do
    it "should set the 'page' cookie" do
      album = create(:album)
      get :show, params: {id: album.id, page: 5}
      expect(cookies[:page]).to eq '5'
    end
  end

end
