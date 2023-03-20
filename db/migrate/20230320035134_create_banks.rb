class CreateBanks < ActiveRecord::Migration[7.0]
  def change
    create_table :banks do |t|
      t.string :bank_name, null: false
      t.string :bank_abbrv, null: false
      t.float :total_balance

      t.timestamps
    end
    add_index :banks, :bank_abbrv, unique: true
    add_index :banks, :bank_name, unique: true
  end
end
