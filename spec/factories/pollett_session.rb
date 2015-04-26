FactoryGirl.define do
  factory :pollett_session, parent: :pollett_context, class: Pollett::Session do
    accessed_at { Time.now.utc }
  end
end
