class AddWorkTypeToWorkers < ActiveRecord::Migration[5.1]
  def change
    add_column :workers, :work_type, :string
  end

  def down
    remove_column :workers, :work_type
  end
end
