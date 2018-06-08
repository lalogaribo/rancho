class CreateWorkers < ActiveRecord::Migration[5.1]
  def change
    create_table :workers do |t|
      t.string :name
      t.string :last_name
      t.integer :phone_number

      t.timestamps
    end
  end
end
