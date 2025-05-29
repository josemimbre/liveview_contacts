defmodule LiveviewContactsWeb.ContactLive.Show do
  use LiveviewContactsWeb, :live_view

  alias LiveviewContacts.Contacts

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        Contact {@contact.id}
        <:subtitle>This is a contact record from your database.</:subtitle>
        <:actions>
          <.button navigate={~p"/contacts"}>
            <.icon name="hero-arrow-left" />
          </.button>
          <.button variant="primary" navigate={~p"/contacts/#{@contact}/edit?return_to=show"}>
            <.icon name="hero-pencil-square" /> Edit contact
          </.button>
        </:actions>
      </.header>

      <.list>
        <:item title="First name">{@contact.first_name}</:item>
        <:item title="Last name">{@contact.last_name}</:item>
        <:item title="Gender">{@contact.gender}</:item>
        <:item title="Birth date">{@contact.birth_date}</:item>
        <:item title="Location">{@contact.location}</:item>
        <:item title="Phone number">{@contact.phone_number}</:item>
        <:item title="Email">{@contact.email}</:item>
        <:item title="Headline">{@contact.headline}</:item>
        <:item title="Picture">{@contact.picture}</:item>
      </.list>
    </Layouts.app>
    """
  end

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Show Contact")
     |> assign(:contact, Contacts.get_contact!(id))}
  end
end
