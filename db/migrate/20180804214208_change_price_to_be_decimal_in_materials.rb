class ChangePriceToBeDecimalInMaterials < ActiveRecord::Migration[5.1]
  def change
    change_column :materials, :price, :decimal
  end
end
