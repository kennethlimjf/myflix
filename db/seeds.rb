# User
User.create( email: "admin@admin.com", password: "adminadmin", full_name: "Admin")

# Category 1: TV Dramas
c1 = Category.create( name: "TV Dramas" )

v1 = Video.create( title: "Family Guy",
              description: "Family Guy is an American adult animated sitcom create\
                            d by Seth MacFarlane for the Fox Broadcasting Company.\
                             The series centers on the Griffins, a family consisti\
                             ng of parents Peter and Lois; their children Meg, Chr\
                             is, and Stewie; and their anthropomorphic pet dog Bri\
                             an. The show is set in the fictional city of Quahog, \
                             Rhode Island, and exhibits much of its humor in the f\
                             orm of cutaway gags that often lampoon American cultu\
                             re.",
              large_cover_url: "/images/family_guy_large.jpg",
              small_cover_url: "/images/thumbnails/family_guy.jpg",
              category: c1 )

Video.create( title: "Futurama",
              description: "Futurama is an American adult animated science fiction\
                            sitcom created by Matt Groening and developed by Groen\
                            ing and David X. Cohen for the Fox Broadcasting Compan\
                            y. The series follows the adventures of a late-20th-ce\
                            ntury New York City pizza delivery boy, Philip J. Fry,\
                             who, after being unwittingly cryogenically frozen for\
                              one thousand years, finds employment at Planet Expre\
                              ss, an interplanetary delivery company in the retro-\
                              futuristic 31st century.",
              large_cover_url: "/images/futurama_large.jpg",
              small_cover_url: "/images/thumbnails/futurama.jpg",
              category: c1 )

Video.create( title: "Monk",
              description: "Monk is an American comedy-drama detective mystery tel\
                            evision series created by Andy Breckman and starring T\
                            ony Shalhoub as the eponymous character, Adrian Monk. \
                            It originally ran from 2002 to 2009 and is primarily a\
                             police procedural series, and also exhibits comic and\
                              dramatic tones in its exploration of the main charac\
                              ters' personal lives.",
              large_cover_url: "/images/monk_large.jpg",
              small_cover_url: "/images/thumbnails/monk.jpg",
              category: c1 )

Video.create( title: "The Godfather",
              description: "Lorem ipsum dolor sit amet, consectetur adipisicing e\
                            lit. Odit quod veritatis deleniti, consectetur modi l\
                            abore odio. Minima eum eius voluptatibus soluta, susci\
                            pit aut accusamus iure distinctio! Nemo quod repellat\
                             vero.",
              large_cover_url: "/images/the_godfather_large.jpg",
              small_cover_url: "/images/thumbnails/the_godfather.jpg",
              category: c1 )

Video.create( title: "The Godfather: Part II",
              description: "Lorem ipsum dolor sit amet, consectetur adipisicing e\
                            lit. Odit quod veritatis deleniti, consectetur modi l\
                            abore odio. Minima eum eius voluptatibus soluta, susci\
                            pit aut accusamus iure distinctio! Nemo quod repellat\
                             vero.",
              large_cover_url: "/images/the_godfather_2_large.jpg",
              small_cover_url: "/images/thumbnails/the_godfather_2.jpg",
              category: c1 )

Video.create( title: "The Godfather: Part III",
              description: "Lorem ipsum dolor sit amet, consectetur adipisicing e\
                            lit. Odit quod veritatis deleniti, consectetur modi l\
                            abore odio. Minima eum eius voluptatibus soluta, susci\
                            pit aut accusamus iure distinctio! Nemo quod repellat\
                             vero.",
              large_cover_url: "/images/the_godfather_3_large.jpg",
              small_cover_url: "/images/thumbnails/the_godfather_3.jpg",
              category: c1 )

Video.create( title: "South Park",
              description: "Lorem ipsum dolor sit amet, consectetur adipisicing e\
                            lit. Odit quod veritatis deleniti, consectetur modi l\
                            abore odio. Minima eum eius voluptatibus soluta, susci\
                            pit aut accusamus iure distinctio! Nemo quod repellat\
                             vero.",
              large_cover_url: "/images/south_park_large.jpg",
              small_cover_url: "/images/thumbnails/south_park.jpg",
              category: c1 )


# Category 2: Documentary
c2 = Category.create( name: "Documentary" )

Video.create( title: "Iron Man",
              description: "Lorem ipsum dolor sit amet, consectetur adipisicing e\
                            lit. Odit quod veritatis deleniti, consectetur modi l\
                            abore odio. Minima eum eius voluptatibus soluta, susci\
                            pit aut accusamus iure distinctio! Nemo quod repellat\
                             vero.",
              large_cover_url: "/images/iron_man_large.jpg",
              small_cover_url: "/images/thumbnails/iron_man.jpg",
              category: c2 )

Video.create( title: "Iron Man II",
              description: "Lorem ipsum dolor sit amet, consectetur adipisicing e\
                            lit. Odit quod veritatis deleniti, consectetur modi l\
                            abore odio. Minima eum eius voluptatibus soluta, susci\
                            pit aut accusamus iure distinctio! Nemo quod repellat\
                             vero.",
              large_cover_url: "/images/iron_man_2_large.jpg",
              small_cover_url: "/images/thumbnails/iron_man_2.jpg",
              category: c2 )

Video.create( title: "The Amazing Spiderman",
              description: "Lorem ipsum dolor sit amet, consectetur adipisicing e\
                            lit. Odit quod veritatis deleniti, consectetur modi l\
                            abore odio. Minima eum eius voluptatibus soluta, susci\
                            pit aut accusamus iure distinctio! Nemo quod repellat\
                             vero.",
              large_cover_url: "/images/the_amazing_spiderman_large.jpg",
              small_cover_url: "/images/thumbnails/the_amazing_spiderman.jpg",
              category: c2 )

Video.create( title: "The Prince of Egypt",
              description: "Lorem ipsum dolor sit amet, consectetur adipisicing e\
                            lit. Odit quod veritatis deleniti, consectetur modi l\
                            abore odio. Minima eum eius voluptatibus soluta, susci\
                            pit aut accusamus iure distinctio! Nemo quod repellat\
                             vero.",
              large_cover_url: "/images/the_prince_of_egypt_large.jpg",
              small_cover_url: "/images/thumbnails/the_prince_of_egypt.jpg",
              category: c2 )

Video.create( title: "Transformers",
              description: "Lorem ipsum dolor sit amet, consectetur adipisicing e\
                            lit. Odit quod veritatis deleniti, consectetur modi l\
                            abore odio. Minima eum eius voluptatibus soluta, susci\
                            pit aut accusamus iure distinctio! Nemo quod repellat\
                             vero.",
              large_cover_url: "/images/transformers_large.jpg",
              small_cover_url: "/images/thumbnails/transformers.jpg",
              category: c2 )

Video.create( title: "The Big Bang Theory",
              description: "Lorem ipsum dolor sit amet, consectetur adipisicing e\
                            lit. Odit quod veritatis deleniti, consectetur modi l\
                            abore odio. Minima eum eius voluptatibus soluta, susci\
                            pit aut accusamus iure distinctio! Nemo quod repellat\
                             vero.",
              large_cover_url: "/images/the_big_bang_theory_large.jpg",
              small_cover_url: "/images/thumbnails/the_big_bang_theory.jpg",
              category: c2 )


# Category 3: Movies
c3 = Category.create( name: "Movies" )

Video.create( title: "Ip Man",
              description: "Lorem ipsum dolor sit amet, consectetur adipisicing e\
                            lit. Odit quod veritatis deleniti, consectetur modi l\
                            abore odio. Minima eum eius voluptatibus soluta, susci\
                            pit aut accusamus iure distinctio! Nemo quod repellat\
                             vero.",
              large_cover_url: "/images/ip_man_large.jpg",
              small_cover_url: "/images/thumbnails/ip_man.jpg",
              category: c3 )

Video.create( title: "Ip Man 2",
              description: "Lorem ipsum dolor sit amet, consectetur adipisicing e\
                            lit. Odit quod veritatis deleniti, consectetur modi l\
                            abore odio. Minima eum eius voluptatibus soluta, susci\
                            pit aut accusamus iure distinctio! Nemo quod repellat\
                             vero.",
              large_cover_url: "/images/ip_man_2_large.jpg",
              small_cover_url: "/images/thumbnails/ip_man_2.jpg",
              category: c3 )

Video.create( title: "Ip Man 3",
              description: "Lorem ipsum dolor sit amet, consectetur adipisicing e\
                            lit. Odit quod veritatis deleniti, consectetur modi l\
                            abore odio. Minima eum eius voluptatibus soluta, susci\
                            pit aut accusamus iure distinctio! Nemo quod repellat\
                             vero.",
              large_cover_url: "/images/ip_man_3_large.jpg",
              small_cover_url: "/images/thumbnails/ip_man_3.jpg",
              category: c3 )


# Category 4: 
Category.create( name: "Oldies" )

# Reviews
Video.first(2).each do |video|
  [3,4,5].sample.times.map { Fabricate(:review, video: video, author: User.first) }
end


# Queue Items
Video.first(5).each_with_index do |video, index|
  q = Fabricate(:queue_item, video: video, user: User.first, list_order: index + 1)
end