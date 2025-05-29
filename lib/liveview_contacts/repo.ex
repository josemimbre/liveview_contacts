defmodule LiveviewContacts.Repo do
  use Ecto.Repo,
    otp_app: :liveview_contacts,
    adapter: Ecto.Adapters.Postgres

  use Scrivener, page_size: 6
end
