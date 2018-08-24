class RemoveWorkerIdFromWorkTypes < ActiveRecord::Migration[5.1]
  def change
    remove_column :worker_types, :worker_id
  end
end
