# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Advisor.Repo.insert!(%Advisor.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias Advisor.Person
alias Advisor.Repo

if Mix.env in [:dev, :ngrok, :ci, :demo] do 
  Repo.delete_all(Person)

  Repo.insert!(%Person{
    name: "Leslie Knope",
    email: "leslie@parks.com",
    is_mentor: true,
    profile_image:
      "https://media1.popsugar-assets.com/files/thumbor/2ebfSQkPUKjxKfb5N3h2N-VIh7U/fit-in/2048xorig/filters:format_auto-!!-:strip_icc-!!-/2015/02/24/097/n/1922283/79e574c2_edit_img_image_845210_1424395524/i/Best-Leslie-Knope-GIFs.png"
  })

  Repo.insert!(%Person{
    name: "Ron Swanson",
    email: "ron@parks.com",
    is_mentor: true,
    profile_image: "https://static.independent.co.uk/s3fs-public/thumbnails/image/2016/10/17/11/ron-swanson.jpg?w968"
  })

  Repo.insert!(%Person{
    name: "April Ludgate",
    email: "april@parks.com",
    is_mentor: true,
    profile_image:
      "https://i.pinimg.com/736x/ba/5f/e0/ba5fe0400e23ffb459b4d078484e6610--aubrey-plaza-aubrey-oday.jpg"
  })

  Repo.insert!(%Person{
    name: "Andy Dwyer",
    email: "andy@parks.com",
    profile_image: "https://pbs.twimg.com/profile_images/618214848975929344/iYgT29Up.jpg"
  })

  Repo.insert!(%Person{
    name: "Tom Haverford",
    email: "tom@parks.com",
    profile_image: "http://cdn.pastemagazine.com/www/blogs/lists/tomhaverford.png?1360172963"
  })

  Repo.insert!(%Person{
    name: "Ann Perkins",
    email: "ann@parks.com",
    profile_image: "https://upload.wikimedia.org/wikipedia/en/3/33/Ann_Perkins.jpg"
  })

  Repo.insert!(%Person{
    name: "Donna Meagle",
    email: "donna@parks.com",
    profile_image:
      "http://vignette4.wikia.nocookie.net/parksandrecreation/images/5/59/Donna_2.jpg/revision/latest?cb=20111015210204"
  })

  Repo.insert!(%Person{
    name: "Ben Wyatt",
    email: "ben@parks.com",
    profile_image:
      "https://vignette.wikia.nocookie.net/parksandrecreation/images/0/0a/Ben.jpg/revision/latest/scale-to-width-down/350?cb=20110809181418"
  })

  Repo.insert!(%Person{name: "Jerry Gergich", email: "jerry@parks.com"})

  Repo.insert!(%Person{
    name: "Chris Traeger",
    email: "chris@parks.com",
    is_mentor: true,
    profile_image: "https://memegenerator.net/img/images/600x600/1993394/chris-traeger.jpg"
  })
end
