class CreateNutrientes < ActiveRecord::Migration[5.1]
  def change
    create_table :nutrientes do |t|
      t.string :nombre
      t.decimal :precio
      t.timestamps
    end
  end
end
