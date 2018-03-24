class CreatePredios < ActiveRecord::Migration[5.1]
  def change
    create_table :predios do |t|
      t.string :name
      t.integer :no_hectareas
      t.timestamps
    end
  end
end
