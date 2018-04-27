class CreateOtrosGastos < ActiveRecord::Migration[5.1]
  def change
    create_table :otros_gastos do |t|
      t.string :nombre
      t.decimal :precio
      t.belongs_to :info_predio, index: true
      t.timestamps
    end
  end
end
