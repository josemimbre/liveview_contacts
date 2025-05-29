defmodule LiveviewContacts.Contacts.Contact do
  use Ecto.Schema
  import Ecto.Changeset

  @genders [
    {0, :male},
    {1, :female}
  ]

  schema "contacts" do
    field :first_name, :string
    field :last_name, :string
    field :gender, :integer
    field :birth_date, :date
    field :location, :string
    field :phone_number, :string
    field :email, :string
    field :headline, :string
    field :picture, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(contact, attrs) do
    contact
    |> cast(attrs, [
      :first_name,
      :last_name,
      :gender,
      :birth_date,
      :location,
      :phone_number,
      :email,
      :headline,
      :picture
    ])
    |> validate_required([
      :first_name,
      :last_name,
      :gender,
      :birth_date,
      :location,
      :phone_number,
      :email,
      :headline,
      :picture
    ])
  end

  @doc """
  Returns genders options
  """
  def genders, do: @genders
end
