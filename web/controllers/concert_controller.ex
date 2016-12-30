defmodule ConcertBooking.ConcertController do
  use ConcertBooking.Web, :controller
  import Ecto.Query, only: [from: 2]

  alias ConcertBooking.Concert


  @page_size 10

  def index(conn, _params) do
    concerts = Repo.all(from(c in Concert, limit: @page_size))
    render(conn, "index.html", concerts: concerts)
  end

  def index_api(conn, %{"page" => page}) do
    page = String.to_integer(page)
    concerts = Repo.all(from(c in Concert,
      limit: @page_size,
      offset: ^((page - 1) * @page_size)))
    json conn, %{
      "page" => page,
      "data" => Enum.map(concerts, &Concert.serialize(&1))
    }
  end

  def index_api(conn, _) do
    json conn, %{
      "code" => "404",
      "message" => "Not found"
    }
  end

  def new(conn, _params) do
    changeset = Concert.changeset(%Concert{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"concert" => concert_params}) do
    changeset = Concert.changeset(%Concert{}, concert_params)

    case Repo.insert(changeset) do
      {:ok, concert} ->
        conn
        |> put_flash(:info, "Concert created successfully.")
        |> redirect(to: concert_path(conn, :show, concert.id))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def create_api(conn, %{"concert" => concert_params}) do
    changeset = Concert.changeset(%Concert{}, concert_params)

    case Repo.insert(changeset) do
      {:ok, concert} ->
        json conn, %{ "redirect_url" => concert_path(conn, :show, concert.id) }
      {:error, changeset} ->
        json conn, %{ "errors" => inspect(changeset.errors) }
    end
  end


  def show(conn, %{"id" => id}) do
    [concert] = Repo.all(from(c in Concert, where: c.id == ^id, preload: :users))

    render(conn, "show.html", concert: concert)
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
