FactoryBot.define do
  factory :coach, class: Coach do
    name { Faker::Name.first_name }
    email { Faker::Internet.email }
    password { Faker::Internet.password(min_length: 8, mix_case: true) }
  end
end
