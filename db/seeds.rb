# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

# User.create!([{
#   email: "yash@yash.com",
#   password: "asdfgh",
#   fullname: "yash shah",
#   is_admin: true,
#   password_confirmation: "asdfgh",
# },
#               {
#   email: "aditi@aditi.com",
#   password: "asdfgh",
#   fullname: "aditi talsania",
#   is_admin: false,
#   password_confirmation: "asdfgh",
# }])

Bank.create!([{
  bank_name: "State Bank Of India",
  bank_abbrv: "SBI",
},
              {
  bank_name: "Union Bank Of India",
  bank_abbrv: "UBI",
}, {
  bank_name: "Central Bank Of India",
  bank_abbrv: "CBI",
}])
