class FixColumnNameWorkersTable < ActiveRecord::Migration[5.1]
  def change
    rename_column :workers, :worker_types_id, :worker_type_id
  end
end
