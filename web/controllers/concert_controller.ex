defmodule ConcertBooking.ConcertController do
  use ConcertBooking.Web, :controller

  alias ConcertBooking.Concert

  def index(conn, _params) do
    concerts = Repo.all(Concert)
    render(conn, "index.html", concerts: concerts)
  end

  def new(conn, _params) do
    changeset = Concert.changeset(%Concert{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"concert" => concert_params}) do
    changeset = Concert.changeset(%Concert{}, concert_params)

    case Repo.insert(changeset) do
      {:ok, _concert} ->
        conn
        |> put_flash(:info, "Concert created successfully.")
        |> redirect(to: concert_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    concert = Repo.get!(Concert, id)
    users = Repo.all(assoc(concert, :users))
    user = get_session(conn, :current_user)

    render(conn, "show.html",
      concert: concert,
      users: users,
      is_booked_ticket: user["id"] in users
    )
  end

  def edit(conn, %{"id" => id}) do
    concert = Repo.get!(Concert, id)
    changeset = Concert.changeset(concert)
    render(conn, "edit.html", concert: concert, changeset: changeset)
  end

  def update(conn, %{"id" => id, "concert" => concert_params}) do
    concert = Repo.get!(Concert, id)
    changeset = Concert.changeset(concert, concert_params)

    case Repo.update(changeset) do
      {:ok, concert} ->
        conn
        |> put_flash(:info, "Concert updated successfully.")
        |> redirect(to: concert_path(conn, :show, concert))
      {:error, changeset} ->
        render(conn, "edit.html", concert: concert, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    concert = Repo.get!(Concert, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(concert)

    conn
    |> put_flash(:info, "Concert deleted successfully.")
    |> redirect(to: concert_path(conn, :index))
  end
end
