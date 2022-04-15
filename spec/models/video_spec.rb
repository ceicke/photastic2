require 'rails_helper'

RSpec.describe Video, type: :model do
  it 'is valid with valid attributes' do
    video = build(:video)
    expect(video).to be_valid
  end

  it 'should default to unprocessed' do
    expect(Video.new.processed?).to be false
  end

  it 'is not valid without a file' do
    video = build(:video, original_file: nil)
    expect(video).to_not be_valid
  end
end
