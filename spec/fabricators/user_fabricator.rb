Fabricator(:user) do
  email { Faker::Internet.email }
  password "password"
  full_name { Faker::Name.name }
  status { true }
end