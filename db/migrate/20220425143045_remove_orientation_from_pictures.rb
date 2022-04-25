class RemoveOrientationFromPictures < ActiveRecord::Migration[7.0]
  def change
    remove_column :pictures, :orientation
  end
end
