Fabricator :invitation do
  name { Faker::Name.name }
  email { Faker::Internet.email }
  message { Faker::Lorem.paragraph(2) }
end