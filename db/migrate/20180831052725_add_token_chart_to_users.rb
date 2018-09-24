class AddTokenChartToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :token_chart, :string
  end
end
