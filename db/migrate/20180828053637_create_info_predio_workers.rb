class CreateInfoPredioWorkers < ActiveRecord::Migration[5.1]
  def change
    create_table :info_predio_workers do |t|
      t.belongs_to :worker, index: true
      t.decimal :precio
      t.belongs_to :info_predio, index: true
      t.timestamps
    end
  end
end
