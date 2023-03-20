json.extract! account, :id, :account_nick_name, :balance, :bank_id, :user_id, :created_at, :updated_at
json.url account_url(account, format: :json)
