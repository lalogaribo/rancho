class CreateInfoPredios < ActiveRecord::Migration[5.1]
  def change
    create_table :info_predios do |t|
      t.decimal :fumigada
      t.decimal :pago_trabaja
      t.integer :conteo_racimos
      t.string :color_cinta
      t.integer :semana
      t.date :fecha_embarque
      t.decimal :precio
      t.decimal :venta
      t.belongs_to :predio, index: true
      t.belongs_to :user, index: true
      t.datetime :deleted_at
      t.timestamps
    end
  end
end
