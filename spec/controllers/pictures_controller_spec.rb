require 'rails_helper'

describe PicturesController do

  before do
    user = create(:user)
    allow(controller).to receive(:authenticate_user!).and_return(true)
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe "#create" do
    it "the job for processing variants is enqueed" do
      ActiveJob::Base.queue_adapter = :test

      album = create(:album)
      picture = build(:picture, album: album)

      expect {
        post :create, params: {
          album_id: album.id,
          picture: {
            description: picture.description,
            file: Rack::Test::UploadedFile.new(Rails.root.join('spec','support', 'test.jpg'), 'image/jpeg')
          }
        }
      }.to have_enqueued_job(ProcessVariantsJob)

    end

    it "redirects to the picture" do
      album = create(:album)
      picture = build(:picture, album: album)

      post :create, params: {
        album_id: album.id,
        picture: {
          description: picture.description,
          file: Rack::Test::UploadedFile.new(Rails.root.join('spec','support', 'test.jpg'), 'image/jpeg')
        }
      }
      expect(response).to redirect_to "/albums/#{album.id}/pictures/1"
    end
  end

end
