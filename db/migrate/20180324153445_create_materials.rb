class CreateMaterials < ActiveRecord::Migration[5.1]
  def change
    create_table :materials do |t|
      t.string :name
      t.integer :price
      t.integer :quantity
      t.timestamps
    end
  end
end
