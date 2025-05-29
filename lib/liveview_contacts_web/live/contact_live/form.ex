defmodule LiveviewContactsWeb.ContactLive.Form do
  use LiveviewContactsWeb, :live_view

  alias LiveviewContacts.Contacts
  alias LiveviewContacts.Contacts.Contact

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        {@page_title}
        <:subtitle>Use this form to manage contact records in your database.</:subtitle>
      </.header>

      <.form for={@form} id="contact-form" phx-change="validate" phx-submit="save">
        <.input field={@form[:first_name]} type="text" label="First name" />
        <.input field={@form[:last_name]} type="text" label="Last name" />
        <.input field={@form[:gender]} type="number" label="Gender" />
        <.input field={@form[:birth_date]} type="date" label="Birth date" />
        <.input field={@form[:location]} type="text" label="Location" />
        <.input field={@form[:phone_number]} type="text" label="Phone number" />
        <.input field={@form[:email]} type="text" label="Email" />
        <.input field={@form[:headline]} type="text" label="Headline" />
        <.input field={@form[:picture]} type="text" label="Picture" />
        <footer>
          <.button phx-disable-with="Saving..." variant="primary">Save Contact</.button>
          <.button navigate={return_path(@return_to, @contact)}>Cancel</.button>
        </footer>
      </.form>
    </Layouts.app>
    """
  end

  @impl true
  def mount(params, _session, socket) do
    {:ok,
     socket
     |> assign(:return_to, return_to(params["return_to"]))
     |> apply_action(socket.assigns.live_action, params)}
  end

  defp return_to("show"), do: "show"
  defp return_to(_), do: "index"

  defp apply_action(socket, :edit, %{"id" => id}) do
    contact = Contacts.get_contact!(id)

    socket
    |> assign(:page_title, "Edit Contact")
    |> assign(:contact, contact)
    |> assign(:form, to_form(Contacts.change_contact(contact)))
  end

  defp apply_action(socket, :new, _params) do
    contact = %Contact{}

    socket
    |> assign(:page_title, "New Contact")
    |> assign(:contact, contact)
    |> assign(:form, to_form(Contacts.change_contact(contact)))
  end

  @impl true
  def handle_event("validate", %{"contact" => contact_params}, socket) do
    changeset = Contacts.change_contact(socket.assigns.contact, contact_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"contact" => contact_params}, socket) do
    save_contact(socket, socket.assigns.live_action, contact_params)
  end

  defp save_contact(socket, :edit, contact_params) do
    case Contacts.update_contact(socket.assigns.contact, contact_params) do
      {:ok, contact} ->
        {:noreply,
         socket
         |> put_flash(:info, "Contact updated successfully")
         |> push_navigate(to: return_path(socket.assigns.return_to, contact))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_contact(socket, :new, contact_params) do
    case Contacts.create_contact(contact_params) do
      {:ok, contact} ->
        {:noreply,
         socket
         |> put_flash(:info, "Contact created successfully")
         |> push_navigate(to: return_path(socket.assigns.return_to, contact))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp return_path("index", _contact), do: ~p"/contacts"
  defp return_path("show", contact), do: ~p"/contacts/#{contact}"
end
