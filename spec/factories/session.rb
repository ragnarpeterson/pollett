FactoryGirl.define do
  factory :session, class: Pollett::Session do
    accessed_at { Time.now.utc }
  end
end
