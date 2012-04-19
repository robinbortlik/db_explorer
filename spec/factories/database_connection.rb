FactoryGirl.define do
  factory :database_connection do
    adapter "sqlite3"
    database "spec/db/test.sqlite3"
  end
end