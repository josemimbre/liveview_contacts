defmodule LiveviewContactsWeb.PageController do
  use LiveviewContactsWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
