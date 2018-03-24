class AddUserIdToPredios < ActiveRecord::Migration[5.1]
  def change
    add_column :predios, :user_id, :integer
  end
end
