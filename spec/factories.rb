FactoryBot.define do
  factory :video do
    original_file { Rack::Test::UploadedFile.new('spec/support/test.mp4') }
    description { Faker::Lorem.sentence }
    status { 0 }
    association :album, factory: :album, strategy: :create
  end

  factory :comment do
    name { Faker::Name.name }
    comment { Faker::Lorem.sentence }
    association :commentable, factory: :picture, strategy: :create
  end

  factory :picture do
    file { Rack::Test::UploadedFile.new('spec/support/test.jpg') }
    description { Faker::Lorem.sentence }
    association :album, factory: :album, strategy: :create
  end

  factory :album do
    name { Faker::Name.first_name }
    passcode { Faker::Internet.password }
  end

  factory :user do
    password = Faker::Internet.password
    email { Faker::Internet.email }
    password { password }
    password_confirmation { password }
  end

end
