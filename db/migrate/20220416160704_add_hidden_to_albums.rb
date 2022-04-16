class AddHiddenToAlbums < ActiveRecord::Migration[7.0]
  def change
    add_column :albums, :hidden, :boolean, default: false
  end
end
