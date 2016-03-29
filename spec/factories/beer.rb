FactoryGirl.define do
  factory :beer do
    brewery { ["Phillips", "Hoyne", "Driftwood"].sample }
    sequence(:name) { |i| "#{["Cypress", "Pine", "Chair Lift", "Red Bird"].sample} ##{i}" }
    style { ["Pilsner", "Lager", "Pale Ale", "IPA", "Stout"].sample }
  end
end
