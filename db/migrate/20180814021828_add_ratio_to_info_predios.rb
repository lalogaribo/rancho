class AddRatioToInfoPredios < ActiveRecord::Migration[5.1]
  def change
    add_column :info_predios, :ratio, :integer
  end
end
