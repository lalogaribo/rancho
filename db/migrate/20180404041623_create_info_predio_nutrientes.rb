class CreateInfoPredioNutrientes < ActiveRecord::Migration[5.1]
  def change
    create_table :info_predio_nutrientes do |t|
      t.belongs_to :info_predio, index: true
      t.belongs_to :nutriente, index: true
      t.timestamps
    end
  end
end
