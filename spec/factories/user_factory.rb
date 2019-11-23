FactoryBot.define do
  factory :user do
    name { 'example_user' }
    display_name { 'Example User' }

    transient do
      password { '123456' }
    end

    trait :admin do
      admin { true }
    end

    before(:create) do |user, evaluator|
      user.password = evaluator.password
      user.password_confirmation = evaluator.password
    end
  end
end

