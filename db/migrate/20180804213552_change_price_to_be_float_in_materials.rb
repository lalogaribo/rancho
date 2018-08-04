class ChangePriceToBeFloatInMaterials < ActiveRecord::Migration[5.1]
  def change
    change_column :materials, :price, :float
  end
end
