class ChangePhoneToBeStringInWorkers < ActiveRecord::Migration[5.1]
  def change
    change_column :workers, :phone_number, :string
  end
end
