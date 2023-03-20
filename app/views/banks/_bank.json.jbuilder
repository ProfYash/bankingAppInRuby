json.extract! bank, :id, :bank_name, :bank_abbrv, :total_balance, :created_at, :updated_at
json.url bank_url(bank, format: :json)
