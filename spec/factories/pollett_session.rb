FactoryGirl.define do
  factory :pollett_session, class: Pollett::Session do
    accessed_at { Time.now.utc }
  end
end
