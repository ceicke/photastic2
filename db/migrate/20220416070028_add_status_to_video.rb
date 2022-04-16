class AddStatusToVideo < ActiveRecord::Migration[7.0]
  def change
    add_column :videos, :status, :integer, default: 0
    remove_column :videos, :processed
  end
end
