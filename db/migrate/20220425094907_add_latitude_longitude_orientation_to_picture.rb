class AddLatitudeLongitudeOrientationToPicture < ActiveRecord::Migration[7.0]
  def change
    add_column :pictures, :latitude, :string
    add_column :pictures, :longitude, :string
    add_column :pictures, :orientation, :string
  end
end
