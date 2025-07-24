defmodule LiveviewContactsWeb.ContactLive.Show do
  use LiveviewContactsWeb, :live_view

  alias LiveviewContacts.Contacts

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        Contact Detail
        <:actions>
          <.button navigate={~p"/contacts"}>
            <.icon name="hero-arrow-left" />
          </.button>
          <.button variant="primary" navigate={~p"/contacts/#{@contact}/edit?return_to=show"}>
            <.icon name="hero-pencil-square" /> Edit contact
          </.button>
        </:actions>
      </.header>
      <.contact_card contact={@contact} />
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
