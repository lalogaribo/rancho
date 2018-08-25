class AddWorkTypeIdToWorkers < ActiveRecord::Migration[5.1]
  def change
    add_column :workers, :worker_types_id, :integer
    remove_column :workers, :work_type
  end
end
