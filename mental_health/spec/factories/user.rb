FactoryBot.define do
  factory :user, class: User do
    name { Faker::Name.first_name }
    email { Faker::Internet.email }
    password { Faker::Internet.password(min_length: 8, mix_case: true) }
  end
end
