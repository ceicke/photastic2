class AddFavoriteToPictures < ActiveRecord::Migration[7.0]
  def change
    add_column :pictures, :favorite, :boolean
  end
end
