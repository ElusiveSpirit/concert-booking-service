defmodule ConcertBooking.SessionController do
  use ConcertBooking.Web, :controller
  alias ConcertBooking.User
  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]


  plug :scrub_params, "user" when action in [:create]


  def new(conn, params) do
    render conn, "new.html", changeset: User.changeset(%User{}), next: params["next"]
  end

  def create(conn, %{"user" => %{"username" => username, "password" => password}, "next" => next})
  when not is_nil(username) and not is_nil(password) do
    user = Repo.get_by(User, username: username)
    next = if next == "", do: "/", else: next

    sign_in(user, password, next, conn)
  end

  def create(conn, _) do
    failed_login(conn)
  end

  def delete(conn, _params) do
    conn
    |> Guardian.Plug.sign_out()
  # |> delete_session(:current_user)
    |> put_flash(:info, "Signed out successfully!")
    |> redirect(to: page_path(conn, :index))
  end

  defp sign_in(user, _password, _next, conn) when is_nil(user) do
    failed_login(conn)
  end

  defp sign_in(user, password, next, conn) do
    if checkpw(password, user.password_digest) do
      conn
      |> Guardian.Plug.sign_in(user)
    # |> put_session(:current_user, %{id: user.id, username: user.username})
      |> put_flash(:info, "Sign in successful!")
      |> redirect(to: next)
    else
      failed_login(conn)
    end
  end

  defp failed_login(conn) do
    dummy_checkpw()
    conn
  # |> put_session(:current_user, nil)
    |> put_flash(:error, "Invalid username/password combination!")
    |> redirect(to: session_path(conn, :new))
    |> halt()
  end
end
