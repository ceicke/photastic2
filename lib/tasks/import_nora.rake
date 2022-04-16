require 'down'

desc 'Import Noras pictures'
task :import_noras_pictures => :environment do
  a = Album.find_by(name: 'Nora')
  if a.nil?
    exit(1)
  end

  json_file = File.read('lib/tasks/pictures.json')
  pictures_hash = JSON.parse(json_file)

  counter = 1

  pictures_hash.each do |picture|
    puts "#{counter} / #{pictures_hash.size}"
    Down.download("https://nora.photasti.cc#{picture['original_url']}", destination: "tmp/nora.jpg")
    p = Picture.new(
      album: a,
      description: picture['description'],
      created_at: picture['created_at']
    )
    p.file.attach(io: File.open('tmp/nora.jpg'), filename: 'test.jpg')
    p.save
    File.delete('tmp/nora.jpg')

    picture['comments'].each do |comment|
      Comment.create(
        commentable: p,
        name: comment['author'],
        comment: comment['comment'],
        created_at: comment['created_at']
      )
    end

    counter += 1
  end
end

desc 'Import Noras videos'
task :import_noras_videos => :environment do
  a = Album.find_by(name: 'Nora')
  if a.nil?
    exit(1)
  end

  json_file = File.read('lib/tasks/videos.json')
  videos_hash = JSON.parse(json_file)

  counter = 1

  videos_hash.each do |video|
    puts "#{counter} / #{videos_hash.size}"
    Down.download("https://nora.photasti.cc#{video['original_url']}", destination: "tmp/nora.mp4")
    v = Video.new(
      album: a,
      description: video['description'],
      created_at: video['created_at']
    )
    v.original_file.attach(io: File.open('tmp/nora.mp4'), filename: 'nora.mp4')
    v.save
    File.delete('tmp/nora.mp4')

    VideoTranscodingJob.perform_later(v)

    video['comments'].each do |comment|
      Comment.create(
        commentable: v,
        name: comment['author'],
        comment: comment['comment'],
        created_at: comment['created_at']
      )
    end

    counter += 1
  end
end
