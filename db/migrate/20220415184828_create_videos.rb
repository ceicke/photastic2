class CreateVideos < ActiveRecord::Migration[7.0]
  def change
    create_table :videos do |t|
      t.text :description
      t.boolean :processed
      t.belongs_to :album, null: false, foreign_key: true

      t.timestamps
    end
  end
end
