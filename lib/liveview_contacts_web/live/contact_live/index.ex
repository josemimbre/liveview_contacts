defmodule LiveviewContactsWeb.ContactLive.Index do
  use LiveviewContactsWeb, :live_view

  alias LiveviewContacts.Contacts

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        Total contacts: {@total_entries}
        <:actions>
          <.search_box search={@search} placeholder="Search contacts..." />
        </:actions>
      </.header>

      <.pagination
        page={@page}
        total_pages={@total_pages}
        on_page_change="paginate"
        show_first_last={true}
      />

      <.card_wrapper
        id="contacts"
        items={@streams.contacts}
        item_url={fn {_id, contact} -> ~p"/contacts/#{contact}" end}
      />
    </Layouts.app>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    search = ""
    page = Contacts.list_page(search: search)

    {:ok,
     socket
     |> assign(:page, 1)
     |> assign(:search, search)
     |> assign(:page_title, "Listing Contacts")
     |> assign(:total_entries, Contacts.count_contacts())
     |> assign(:total_pages, page.total_pages)
     |> stream(:contacts, page.entries)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    contact = Contacts.get_contact!(id)
    {:ok, _} = Contacts.delete_contact(contact)

    {:noreply, stream_delete(socket, :contacts, contact)}
  end

  @impl true
  def handle_event("paginate", %{"page" => page}, socket) do
    page_number = String.to_integer(page)
    contacts_page = Contacts.list_page(page: page_number, search: socket.assigns.search)

    {:noreply,
     socket
     |> assign(:page, page_number)
     |> stream(:contacts, [], reset: true)
     |> stream(:contacts, contacts_page.entries)}
  end

  @impl true
  def handle_event("search", %{"search" => search}, socket) do
    page = Contacts.list_page(page: 1, search: search)

    {:noreply,
     socket
     |> assign(:search, search)
     |> assign(:page, 1)
     |> assign(:total_pages, page.total_pages)
     |> stream(:contacts, [], reset: true)
     |> stream(:contacts, page.entries)}
  end
end
