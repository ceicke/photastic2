class CreateUserAlbumAssociations < ActiveRecord::Migration[7.0]
  def change
    create_table :user_album_associations do |t|
      t.belongs_to :user
      t.belongs_to :album
      t.timestamps
    end
  end
end
