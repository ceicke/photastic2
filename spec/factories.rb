FactoryBot.define do
  factory :picture do
    file { Rack::Test::UploadedFile.new('spec/support/test.jpg') }
    description { Faker::Lorem.sentence }
    album
  end

  factory :album do
    name { Faker::Name.first_name }
    passcode { Faker::String.random(length: 8) }
  end


end
