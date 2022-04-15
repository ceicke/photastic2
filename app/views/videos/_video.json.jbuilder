json.extract! video, :id, :description, :album_id, :created_at, :updated_at
json.url video_url(video, format: :json)
