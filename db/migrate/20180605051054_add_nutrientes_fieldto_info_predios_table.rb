class AddNutrientesFieldtoInfoPrediosTable < ActiveRecord::Migration[5.1]
  def change
    add_column :info_predios, :nutriente, :decimal
    drop_table :info_predio_nutrientes
    drop_table :nutrientes
  end
end
