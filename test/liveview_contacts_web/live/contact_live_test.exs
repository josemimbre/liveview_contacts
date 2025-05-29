defmodule LiveviewContactsWeb.ContactLiveTest do
  use LiveviewContactsWeb.ConnCase

  import Phoenix.LiveViewTest
  import LiveviewContacts.ContactsFixtures

  @create_attrs %{
    location: "some location",
    first_name: "some first_name",
    last_name: "some last_name",
    gender: 42,
    birth_date: "2025-05-14",
    phone_number: "some phone_number",
    email: "some email",
    headline: "some headline",
    picture: "some picture"
  }
  @update_attrs %{
    location: "some updated location",
    first_name: "some updated first_name",
    last_name: "some updated last_name",
    gender: 43,
    birth_date: "2025-05-15",
    phone_number: "some updated phone_number",
    email: "some updated email",
    headline: "some updated headline",
    picture: "some updated picture"
  }
  @invalid_attrs %{
    location: nil,
    first_name: nil,
    last_name: nil,
    gender: nil,
    birth_date: nil,
    phone_number: nil,
    email: nil,
    headline: nil,
    picture: nil
  }
  defp create_contact(_) do
    contact = contact_fixture()

    %{contact: contact}
  end

  describe "Index" do
    setup [:create_contact]

    test "lists all contacts", %{conn: conn, contact: contact} do
      {:ok, _index_live, html} = live(conn, ~p"/contacts")

      assert html =~ "Listing Contacts"
      assert html =~ contact.first_name
    end

    test "saves new contact", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/contacts")

      assert {:ok, form_live, _} =
               index_live
               |> element("a", "New Contact")
               |> render_click()
               |> follow_redirect(conn, ~p"/contacts/new")

      assert render(form_live) =~ "New Contact"

      assert form_live
             |> form("#contact-form", contact: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#contact-form", contact: @create_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/contacts")

      html = render(index_live)
      assert html =~ "Contact created successfully"
      assert html =~ "some first_name"
    end

    test "updates contact in listing", %{conn: conn, contact: contact} do
      {:ok, index_live, _html} = live(conn, ~p"/contacts")

      assert {:ok, form_live, _html} =
               index_live
               |> element("#contacts-#{contact.id} a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/contacts/#{contact}/edit")

      assert render(form_live) =~ "Edit Contact"

      assert form_live
             |> form("#contact-form", contact: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#contact-form", contact: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/contacts")

      html = render(index_live)
      assert html =~ "Contact updated successfully"
      assert html =~ "some updated first_name"
    end

    test "deletes contact in listing", %{conn: conn, contact: contact} do
      {:ok, index_live, _html} = live(conn, ~p"/contacts")

      assert index_live |> element("#contacts-#{contact.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#contacts-#{contact.id}")
    end
  end

  describe "Show" do
    setup [:create_contact]

    test "displays contact", %{conn: conn, contact: contact} do
      {:ok, _show_live, html} = live(conn, ~p"/contacts/#{contact}")

      assert html =~ "Show Contact"
      assert html =~ contact.first_name
    end

    test "updates contact and returns to show", %{conn: conn, contact: contact} do
      {:ok, show_live, _html} = live(conn, ~p"/contacts/#{contact}")

      assert {:ok, form_live, _} =
               show_live
               |> element("a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/contacts/#{contact}/edit?return_to=show")

      assert render(form_live) =~ "Edit Contact"

      assert form_live
             |> form("#contact-form", contact: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, show_live, _html} =
               form_live
               |> form("#contact-form", contact: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/contacts/#{contact}")

      html = render(show_live)
      assert html =~ "Contact updated successfully"
      assert html =~ "some updated first_name"
    end
  end
end
