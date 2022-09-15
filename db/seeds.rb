# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

b1 = Brewery.create name: "Koff", year: 1897
b2 = Brewery.create name: "Malmgard", year: 2001
b3 = Brewery.create name: "Weihenstephaner", year: 1040

b1.beers.create name: "Iso 3", style: "Lager"
karhu = b1.beers.create name: "Karhu", style: "Lager"
b1.beers.create name: "Tuplahumala", style: "Lager"
b2.beers.create name: "Huvila Pale Ale", style: "Pale Ale"
b2.beers.create name: "X Porter", style: "Porter"
b3.beers.create name: "Hefeweizen", style: "Weizen"
helles = b3.beers.create name: "Helles", style: "Lager"

u1 = User.create username: "Olli", password: "Kalja1", password_confirmation: "Kalja1"
u2 = User.create username: "Vilma", password: "Sala123", password_confirmation: "Sala123"

karhu.ratings.create score: 70, user_id: u1.id
karhu.ratings.create score: 35, user_id: u2.id
helles.ratings.create score: 20, user_id: u2.id

bc1 = BeerClub.create name: "Kumpulan kaljakerho", founded: 2018, city: "Helsinki"
Membership.create beer_club_id: bc1.id, user_id: u1.id
