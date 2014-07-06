Fabricator :review do
  author { Fabricate(:user) }
  rating { %w(1 2 3 4 5).sample }
  created_at { Time.now }
  updated_at { Time.now }
  body { Faker::Lorem.paragraph(5) }
end