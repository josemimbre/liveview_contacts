defmodule LiveviewContacts.ContactsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `LiveviewContacts.Contacts` context.
  """

  @doc """
  Generate a contact.
  """
  def contact_fixture(attrs \\ %{}) do
    {:ok, contact} =
      attrs
      |> Enum.into(%{
        birth_date: ~D[2025-05-14],
        email: "some email",
        first_name: "some first_name",
        gender: 42,
        headline: "some headline",
        last_name: "some last_name",
        location: "some location",
        phone_number: "some phone_number",
        picture: "some picture"
      })
      |> LiveviewContacts.Contacts.create_contact()

    contact
  end
end
