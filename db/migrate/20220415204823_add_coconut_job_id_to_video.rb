class AddCoconutJobIdToVideo < ActiveRecord::Migration[7.0]
  def change
    add_column :videos, :coconut_job_id, :string
  end
end
