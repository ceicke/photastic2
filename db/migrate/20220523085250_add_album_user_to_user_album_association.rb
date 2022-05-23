class AddAlbumUserToUserAlbumAssociation < ActiveRecord::Migration[7.0]
  def change
    add_column :user_album_associations, :album_user, :boolean
  end
end
