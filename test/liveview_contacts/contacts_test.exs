defmodule LiveviewContacts.ContactsTest do
  use LiveviewContacts.DataCase

  alias LiveviewContacts.Contacts

  describe "contacts" do
    alias LiveviewContacts.Contacts.Contact

    import LiveviewContacts.ContactsFixtures

    @invalid_attrs %{
      location: nil,
      first_name: nil,
      last_name: nil,
      gender: nil,
      birth_date: nil,
      phone_number: nil,
      email: nil,
      headline: nil,
      picture: nil
    }

    test "list_contacts/0 returns all contacts" do
      contact = contact_fixture()
      assert Contacts.list_contacts() == [contact]
    end

    test "get_contact!/1 returns the contact with given id" do
      contact = contact_fixture()
      assert Contacts.get_contact!(contact.id) == contact
    end

    test "create_contact/1 with valid data creates a contact" do
      valid_attrs = %{
        location: "some location",
        first_name: "some first_name",
        last_name: "some last_name",
        gender: 42,
        birth_date: ~D[2025-05-14],
        phone_number: "some phone_number",
        email: "some email",
        headline: "some headline",
        picture: "some picture"
      }

      assert {:ok, %Contact{} = contact} = Contacts.create_contact(valid_attrs)
      assert contact.location == "some location"
      assert contact.first_name == "some first_name"
      assert contact.last_name == "some last_name"
      assert contact.gender == 42
      assert contact.birth_date == ~D[2025-05-14]
      assert contact.phone_number == "some phone_number"
      assert contact.email == "some email"
      assert contact.headline == "some headline"
      assert contact.picture == "some picture"
    end

    test "create_contact/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Contacts.create_contact(@invalid_attrs)
    end

    test "update_contact/2 with valid data updates the contact" do
      contact = contact_fixture()

      update_attrs = %{
        location: "some updated location",
        first_name: "some updated first_name",
        last_name: "some updated last_name",
        gender: 43,
        birth_date: ~D[2025-05-15],
        phone_number: "some updated phone_number",
        email: "some updated email",
        headline: "some updated headline",
        picture: "some updated picture"
      }

      assert {:ok, %Contact{} = contact} = Contacts.update_contact(contact, update_attrs)
      assert contact.location == "some updated location"
      assert contact.first_name == "some updated first_name"
      assert contact.last_name == "some updated last_name"
      assert contact.gender == 43
      assert contact.birth_date == ~D[2025-05-15]
      assert contact.phone_number == "some updated phone_number"
      assert contact.email == "some updated email"
      assert contact.headline == "some updated headline"
      assert contact.picture == "some updated picture"
    end

    test "update_contact/2 with invalid data returns error changeset" do
      contact = contact_fixture()
      assert {:error, %Ecto.Changeset{}} = Contacts.update_contact(contact, @invalid_attrs)
      assert contact == Contacts.get_contact!(contact.id)
    end

    test "delete_contact/1 deletes the contact" do
      contact = contact_fixture()
      assert {:ok, %Contact{}} = Contacts.delete_contact(contact)
      assert_raise Ecto.NoResultsError, fn -> Contacts.get_contact!(contact.id) end
    end

    test "change_contact/1 returns a contact changeset" do
      contact = contact_fixture()
      assert %Ecto.Changeset{} = Contacts.change_contact(contact)
    end
  end
end
