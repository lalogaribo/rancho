class CreateInfoPredios < ActiveRecord::Migration[5.1]
  def change
    create_table :info_predios do |t|
      t.decimal :fumigada
      t.decimal :pago_trabaja
      t.integer :conteo_racimos
      t.string :color_cinta
      t.integer :semana
      t.belongs_to :predio, index: true
      t.integer :user_id
      t.datetime :deleted_at
      t.timestamps
    end
  end
end
