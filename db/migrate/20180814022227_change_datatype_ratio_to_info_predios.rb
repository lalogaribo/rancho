class ChangeDatatypeRatioToInfoPredios < ActiveRecord::Migration[5.1]
  def change
    change_column :info_predios, :ratio, :decimal
  end
end
