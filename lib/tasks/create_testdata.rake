require 'down'

desc 'Create albums with images for development'
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
        Comment.create(commentable: picture, name: Faker::Name.name, comment: Faker::Lorem.sentence)
        print '📝 '
      end
    end
  end
  File.delete('tmp/tmp_file.jpg')
end

desc 'Create one big album with 200 pictures for development'
task :hello_big_world => :environment do
  1.times do
    album = Album.create(name: Faker::Name.first_name, passcode: Faker::String.random(length: 8))
    print '📔 '
    200.times do
      Down.download("https://picsum.photos/1500/1300", destination: "tmp/tmp_file.jpg")
      picture = Picture.new(album: album, description: Faker::Lorem.sentence)
      picture.file.attach(io: File.open('tmp/tmp_file.jpg'), filename: 'test.jpg')
      picture.save
      ProcessVariantsJob.perform_later(picture)
      print '📷 '
      rand(0..3).times do
        Comment.create(commentable: picture, name: Faker::Name.name, comment: Faker::Lorem.sentence)
        print '📝 '
      end
    end
  end
  File.delete('tmp/tmp_file.jpg')
end

desc 'Create albums with videos for development'
task :hello_movie_world => :environment do
  rand(2..5).times do
    album = Album.create(name: "Videos: #{Faker::Name.first_name}", passcode: Faker::String.random(length: 8))
    print '📔 '
    rand(8..12).times do
      video = Video.new(album: album, description: Faker::Lorem.sentence)
      video.original_file.attach(io: File.open('spec/support/test.mp4'), filename: 'test.mp4')
      video.save
      print '📹 '
    end
  end
end
