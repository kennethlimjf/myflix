Fabricator(:video) do
  title { Faker::Lorem.sentence(4) }
  description { Faker::Lorem.paragraph(2) }
  created_at Time.now
  updated_at Time.now
end