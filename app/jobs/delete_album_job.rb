class DeleteAlbumJob < ApplicationJob
  queue_as :default

  def perform(album)
    album.destroy
  end

end
