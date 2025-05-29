# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     LiveviewContacts.Repo.insert!(%LiveviewContacts.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias LiveviewContacts.Repo
alias LiveviewContacts.Contacts
alias LiveviewContacts.Contacts.Contact

IO.puts("---- Deleting existing contacts")

Repo.delete_all(Contact)

IO.puts("---- Creating people")

for index <- 1..100 do
  {gender_id, gender_name} = Enum.random(Contact.genders())

  gender_name = to_string(gender_name)

  picture_gender =
    case gender_name do
      "male" -> "men"
      _ -> "women"
    end

  params = %{
    first_name: Faker.Person.first_name(),
    last_name: Faker.Person.last_name(),
    gender: gender_id,
    birth_date: Faker.Date.date_of_birth(),
    location: Faker.Address.country(),
    phone_number: Faker.Phone.EnUs.phone(),
    email: Faker.Internet.email(),
    picture: "https://randomuser.me/api/portraits/#{picture_gender}/#{index}.jpg",
    headline: Faker.Lorem.sentence(3)
  }

  # result = Repo.insert!(contact)
  {:ok, contact} = Contacts.create_contact(params)

  IO.puts("---- Inserted contact #{contact.id}")
end
