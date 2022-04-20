require "rails_helper"

RSpec.describe PicturesHelper, :type => :helper do
  describe "#generate_back_link" do
    it "generates a link with page param" do
      cookies[:page] = '5'
      picture = create(:picture)
      expect(helper.generate_back_link(picture.album, picture)).to include('page=')
    end

    it "generates a link without page param" do
      picture = create(:picture)
      expect(helper.generate_back_link(picture.album, picture)).to_not include('page=')
    end
  end
end
