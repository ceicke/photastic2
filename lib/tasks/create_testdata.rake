require 'down'

desc 'Create testdata for development'
task :hello_world => :environment do
  rand(2..5).times do
    album = Album.create(name: Faker::Name.first_name, passcode: Faker::String.random(length: 8))
    print '📔 '
    rand(8..12).times do
      Down.download("https://picsum.photos/1500/1300", destination: "tmp/tmp_file.jpg")
      picture = Picture.new(album: album, description: Faker::Lorem.sentence)
      picture.file.attach(io: File.open('tmp/tmp_file.jpg'), filename: 'test.jpg')
      picture.save
      print '📷 '
      rand(0..3).times do
        Comment.create(picture: picture, name: Faker::Name.name, comment: Faker::Lorem.sentence)
        print '📝 '
      end
    end
  end
  File.delete('tmp/tmp_file.jpg')
end
