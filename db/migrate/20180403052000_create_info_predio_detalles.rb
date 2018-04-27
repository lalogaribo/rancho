class CreateInfoPredioDetalles < ActiveRecord::Migration[5.1]
  def change
    create_table :info_predio_detalles do |t|
      t.belongs_to :material, index: true
      t.integer :cantidad
      t.belongs_to :info_predio, index: true

      t.timestamps
    end
  end
end
