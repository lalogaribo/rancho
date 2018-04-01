class CreateMateriales < ActiveRecord::Migration[5.1]
  def change
    create_table :materiales do |t|
      t.string :name
      t.integer :price
      t.integer :quantity
      t.timestamps
    end
  end
end
