Fabricator(:video) do
  category

  title { Faker::Lorem.sentence(4) }
  description { Faker::Lorem.paragraph(2) }
  large_cover_url "large_cover_url.jpg"
  large_cover_url "small_cover_url.jpg"
  created_at Time.now
  updated_at Time.now
end