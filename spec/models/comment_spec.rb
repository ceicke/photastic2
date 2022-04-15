require 'rails_helper'

RSpec.describe Comment, type: :model do
  it 'is valid with valid attributes' do
    comment = build(:comment)
    expect(comment).to be_valid
  end

  it 'is not valid without a name' do
    comment = build(:comment, name: nil)
    expect(comment).to_not be_valid
  end

  it 'is not valid without a comment' do
    comment = build(:comment, comment: nil)
    expect(comment).to_not be_valid
  end
end
