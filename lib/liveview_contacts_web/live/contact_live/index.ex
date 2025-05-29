defmodule LiveviewContactsWeb.ContactLive.Index do
  use LiveviewContactsWeb, :live_view

  alias LiveviewContacts.Contacts

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        Listing Contacts
        <:subtitle>
          Total contacts: {@total_entries}
        </:subtitle>
      </.header>

      <div class="flex justify-center my-6">
        <nav class="join">
          <button
            class="join-item btn"
            phx-click="paginate"
            phx-value-page={max(@page - 1, 1)}
            disabled={@page == 1}
          >
            «
          </button>
          <button class="join-item btn">
            {@page}
          </button>
          <button
            class="join-item btn"
            phx-click="paginate"
            phx-value-page={min(@page + 1, @total_entries)}
            disabled={@page == @total_pages}
          >
            »
          </button>
        </nav>
      </div>

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
    page = Contacts.list_page()

    {:ok,
     socket
     |> assign(:page, 1)
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
    contacts_page = Contacts.list_page(page: page_number)

    {:noreply,
     socket
     |> assign(:page, page_number)
     |> stream(:contacts, [], reset: true)
     |> stream(:contacts, contacts_page.entries)}
  end
end
