FactoryBot.define do
  factory :difficulty_level do
    sequence(:level) { |n| "Level #{n}" }
  end

  factory :tag do
    sequence(:tag) { |n| "Tag #{n}" }
  end

  factory :language do
    sequence(:language) { |n| "Language #{n}" }
  end

  factory :problem do
    sequence(:title) { |n| "Problem #{n}" }
    level
    tags { [create(:tag)] }
    languages { [create(:language)] }
  end
end
