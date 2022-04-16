class CreateComments < ActiveRecord::Migration[7.0]
  def change
    create_table :comments do |t|
      t.string :name
      t.text :comment
      t.bigint :commentable_id
      t.string :commentable_type

      t.timestamps
    end

    add_index :comments, [:commentable_type, :commentable_id]
  end
end
