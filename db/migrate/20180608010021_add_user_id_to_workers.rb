class AddUserIdToWorkers < ActiveRecord::Migration[5.1]
  def change
    add_column :workers, :user_id, :integer
  end
end
