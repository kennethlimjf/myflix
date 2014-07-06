Fabricator(:category) do
  name { Faker::Lorem.sentence(5) }
  created_at Time.now
  updated_at Time.now
end