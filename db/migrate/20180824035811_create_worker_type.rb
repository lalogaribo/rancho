class CreateWorkerType < ActiveRecord::Migration[5.1]
  def change
    create_table :worker_types do |t|
      t.string :name
      t.integer :worker_id
    end
  end
end
