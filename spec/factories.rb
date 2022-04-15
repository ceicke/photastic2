FactoryBot.define do
  factory :comment do
    name { Faker::Name.name }
    comment { Faker::Lorem.sentence }
    association :picture, factory: :picture, strategy: :create
  end

  factory :picture do
    file { Rack::Test::UploadedFile.new('spec/support/test.jpg') }
    description { Faker::Lorem.sentence }
    association :album, factory: :album, strategy: :create
  end

  factory :album do
    name { Faker::Name.first_name }
    passcode { Faker::String.random(length: 8) }
  end

end
