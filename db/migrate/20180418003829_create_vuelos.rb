class CreateVuelos < ActiveRecord::Migration[5.1]
  def change
    create_table :vuelos do |t|
      t.references :user, foreign_key: true
      t.string :predio
      t.string :aplicacion
      t.string :piloto
      t.integer :precio_vuelo
      t.timestamps
    end
  end
end
