require 'rails_helper'

RSpec.describe Video, type: :model do
  it 'is valid with valid attributes' do
    video = build(:video)
    expect(video).to be_valid
  end

  it 'should default to queued' do
    expect(Video.new.queued?).to be true
  end

  it 'is not valid without a file' do
    video = build(:video, original_file: nil)
    expect(video).to_not be_valid
  end

  it 'defaults to the status "queued"' do
    video = Video.new
    expect(video.queued?).to be(true)
  end
end
