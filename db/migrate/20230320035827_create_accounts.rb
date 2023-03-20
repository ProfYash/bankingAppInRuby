class CreateAccounts < ActiveRecord::Migration[7.0]
  def change
    create_table :accounts do |t|
      t.string :account_nick_name, null: false
      t.float :balance, default: 1000.0, null: false
      t.integer :bank_id, null: false
      t.integer :user_id, null: false

      t.timestamps
    end
  end
end
