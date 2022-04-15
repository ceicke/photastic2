class CreatePictures < ActiveRecord::Migration[7.0]
  def change
    create_table :pictures do |t|
      t.string :description
      t.integer :album_id

      t.timestamps
    end
  end
end
