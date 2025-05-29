defmodule LiveviewContacts.Contacts do
  @moduledoc """
  The Contacts context.
  """

  import Ecto.Query, warn: false
  alias LiveviewContacts.Repo

  alias LiveviewContacts.Contacts.Contact

  @doc """
  Returns the list of contacts.

  ## Examples

      iex> list_contacts()
      [%Contact{}, ...]

      iex> list_contacts(limit: 10, offset: 0)
      [%Contact{}, ...]

  """
  def list_contacts do
    Repo.all(Contact)
  end

  @doc """
    Returns a paginated list of contacts
  """

  def list_page(params \\ []) do
    Contact
    |> Repo.paginate(params)
  end

  @doc """
  Returns the total count of contacts.

  ## Examples

      iex> count_contacts()
      42

  """
  def count_contacts do
    Contact
    |> Repo.aggregate(:count)
  end

  @doc """
  Gets a single contact.

  Raises `Ecto.NoResultsError` if the Contact does not exist.

  ## Examples

      iex> get_contact!(123)
      %Contact{}

      iex> get_contact!(456)
      ** (Ecto.NoResultsError)

  """
  def get_contact!(id), do: Repo.get!(Contact, id)

  @doc """
  Creates a contact.

  ## Examples

      iex> create_contact(%{field: value})
      {:ok, %Contact{}}

      iex> create_contact(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_contact(attrs) do
    %Contact{}
    |> Contact.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a contact.

  ## Examples

      iex> update_contact(contact, %{field: new_value})
      {:ok, %Contact{}}

      iex> update_contact(contact, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_contact(%Contact{} = contact, attrs) do
    contact
    |> Contact.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a contact.

  ## Examples

      iex> delete_contact(contact)
      {:ok, %Contact{}}

      iex> delete_contact(contact)
      {:error, %Ecto.Changeset{}}

  """
  def delete_contact(%Contact{} = contact) do
    Repo.delete(contact)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking contact changes.

  ## Examples

      iex> change_contact(contact)
      %Ecto.Changeset{data: %Contact{}}

  """
  def change_contact(%Contact{} = contact, attrs \\ %{}) do
    Contact.changeset(contact, attrs)
  end
end
