class AddUserIdToMaterials < ActiveRecord::Migration[5.1]
  def change
    add_column :materials, :user_id, :integer
  end
end
