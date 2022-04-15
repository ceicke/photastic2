json.extract! picture, :id, :file, :description, :created_at, :updated_at
json.url picture_url(picture, format: :json)
json.file url_for(picture.file)
