require 'net/http'

desc 'Create testdata for development'
task :hello_world => :environment do
  rand(3..10).times do
    album = Album.create(name: Faker::Name.first_name, passcode: Faker::String.random(length: 8))
    rand(10..30).times do
      File.write('tmp/tmp_file.jpg', Net::HTTP.get(URI.parse('https://picsum.photos/200/300')))
      picture = Picture.new(album: album, description: Faker::Lorem.sentence)
      picture.file = Rack::Test::UploadedFile.new('tmp/tmp_file.jpg')
      rand(0..3).times do
        Comment.create(picture: picture, name: Faker::Name.name, comment: Faker::Lorem.sentence)
      end
    end
  end
  File.delete('tmp/tmp_file.jpg')
end
