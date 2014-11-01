FactoryGirl.define do
  factory :user do
    email "user@example.com"
    password "foobar"
    password_confirmation "foobar"
    name "user"
    sequence(:firstname) {|i| "Janez#{i}"}
    sequence(:lastname) {|i| "Novak#{i}"}
    sex 1
    birthday "20-11-2001"
    latitude 19.191
    longitude 10.2992
  end
end
