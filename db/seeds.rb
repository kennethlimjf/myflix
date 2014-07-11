# User
user = User.create( email: "admin@admin.com", password: "adminadmin", full_name: "Admin", admin: true)

# Category 1: TV Dramas
c1 = Category.create( name: "TV Dramas" )

v1 = Video.create(  title: "Family Guy",
                    description: Faker::Lorem.paragraph(3),
                    cover: "family_guy.jpg",
                    video_url: 'https://s3-ap-southeast-1.amazonaws.com/movix/videos/IU+-+Wallpaper+Design.mp4',
                    category: c1 )

Video.create(  title: "Futurama",
                    description: Faker::Lorem.paragraph(3),
                    cover: "futurama.jpg",
                    video_url: 'https://s3-ap-southeast-1.amazonaws.com/movix/videos/IU+-+Wallpaper+Design.mp4',
                    category: c1 )

Video.create( title: "Monk",
              description: Faker::Lorem.paragraph(3),
              cover: "monk.jpg",
              video_url: 'https://s3-ap-southeast-1.amazonaws.com/movix/videos/IU+-+Wallpaper+Design.mp4',
              category: c1 )

Video.create( title: "The Godfather",
              description: Faker::Lorem.paragraph(3),
              cover: "the_godfather.jpg",
              video_url: 'https://s3-ap-southeast-1.amazonaws.com/movix/videos/IU+-+Wallpaper+Design.mp4',
              category: c1 )

Video.create( title: "The Godfather: Part II",
              description: Faker::Lorem.paragraph(3),
              cover: "the_godfather_2.jpg",
              video_url: 'https://s3-ap-southeast-1.amazonaws.com/movix/videos/IU+-+Wallpaper+Design.mp4',
              category: c1 )

Video.create( title: "The Godfather: Part III",
              description: Faker::Lorem.paragraph(3),
              cover: "the_godfather_3.jpg",
              video_url: 'https://s3-ap-southeast-1.amazonaws.com/movix/videos/IU+-+Wallpaper+Design.mp4',
              category: c1 )

Video.create( title: "South Park",
              description: Faker::Lorem.paragraph(3),
              cover: "south_park.jpg",
              video_url: 'https://s3-ap-southeast-1.amazonaws.com/movix/videos/IU+-+Wallpaper+Design.mp4',
              category: c1 )


# Category 2: Documentary
c2 = Category.create( name: "Documentary" )

Video.create( title: "Iron Man",
              description: Faker::Lorem.paragraph(3),
              cover: "iron_man.jpg",
              video_url: 'https://s3-ap-southeast-1.amazonaws.com/movix/videos/IU+-+Wallpaper+Design.mp4',
              category: c2 )

Video.create( title: "Iron Man II",
              description: Faker::Lorem.paragraph(3),
              cover: "iron_man_2.jpg",
              video_url: 'https://s3-ap-southeast-1.amazonaws.com/movix/videos/IU+-+Wallpaper+Design.mp4',
              category: c2 )

Video.create( title: "The Amazing Spiderman",
              description: Faker::Lorem.paragraph(3),
              cover: "the_amazing_spiderman.jpg",
              video_url: 'https://s3-ap-southeast-1.amazonaws.com/movix/videos/IU+-+Wallpaper+Design.mp4',
              category: c2 )

Video.create( title: "The Prince of Egypt",
              description: Faker::Lorem.paragraph(3),
              cover: "the_prince_of_egypt.jpg",
              video_url: 'https://s3-ap-southeast-1.amazonaws.com/movix/videos/IU+-+Wallpaper+Design.mp4',
              category: c2 )

Video.create( title: "Transformers",
              description: Faker::Lorem.paragraph(3),
              cover: "transformers.jpg",
              video_url: 'https://s3-ap-southeast-1.amazonaws.com/movix/videos/IU+-+Wallpaper+Design.mp4',
              category: c2 )

Video.create( title: "The Big Bang Theory",
              description: Faker::Lorem.paragraph(3),
              cover: "the_big_bang_theory.jpg",
              video_url: 'https://s3-ap-southeast-1.amazonaws.com/movix/videos/IU+-+Wallpaper+Design.mp4',
              category: c2 )


# Category 3: Movies
c3 = Category.create( name: "Movies" )

Video.create( title: "Ip Man",
              description: Faker::Lorem.paragraph(3),
              cover: "ip_man.jpg",
              video_url: 'https://s3-ap-southeast-1.amazonaws.com/movix/videos/IU+-+Wallpaper+Design.mp4',
              category: c3 )

Video.create( title: "Ip Man 2",
              description: Faker::Lorem.paragraph(3),
              cover: "ip_man_2.jpg",
              video_url: 'https://s3-ap-southeast-1.amazonaws.com/movix/videos/IU+-+Wallpaper+Design.mp4',
              category: c3 )

Video.create( title: "Ip Man 3",
              description: Faker::Lorem.paragraph(3),
              cover: "ip_man_3.jpg",
              video_url: 'https://s3-ap-southeast-1.amazonaws.com/movix/videos/IU+-+Wallpaper+Design.mp4',
              category: c3 )


# Reviews
another_user = Fabricate(:user)
Video.first(2).each do |video|
  [3,4,5].sample.times.map { Fabricate(:review, video: video, author: another_user) }
end

# Queue Items
Video.first(5).each_with_index do |video, index|
  q = Fabricate(:queue_item, video: video, user: User.first, list_order: index + 1)
end


# Follows
user.follow_users << Fabricate(:user)
user.follow_users << Fabricate(:user)
user.follow_users << Fabricate(:user)
