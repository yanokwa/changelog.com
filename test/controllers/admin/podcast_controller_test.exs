defmodule Changelog.Admin.PodcastControllerTest do
  use Changelog.ConnCase

  alias Changelog.Podcast

  @valid_attrs %{name: "Polyglot", slug: "polyglot"}
  @invalid_attrs %{name: "Polyglot", slug: ""}

  defp podcast_count(query), do: Repo.one(from p in query, select: count(p.id))

  @tag :as_admin
  test "lists all podcasts", %{conn: conn} do
    p1 = create(:podcast)
    p2 = create(:podcast)

    conn = get conn, admin_podcast_path(conn, :index)

    assert html_response(conn, 200) =~ ~r/Podcasts/
    assert String.contains?(conn.resp_body, p1.name)
    assert String.contains?(conn.resp_body, p2.name)
  end

  test "requires user auth on all actions" do
    Enum.each([
      get(conn, admin_podcast_path(conn, :index)),
      get(conn, admin_podcast_path(conn, :new)),
      post(conn, admin_podcast_path(conn, :create), podcast: @valid_attrs),
      get(conn, admin_podcast_path(conn, :edit, "123")),
      put(conn, admin_podcast_path(conn, :update, "123"), podcast: @valid_attrs),
      delete(conn, admin_podcast_path(conn, :delete, "123")),
    ], fn conn ->
      assert html_response(conn, 302)
      assert conn.halted
    end)
  end
end
