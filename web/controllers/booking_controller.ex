defmodule ConcertBooking.BookingController do
  use ConcertBooking.Web, :controller

  def create(conn, %{"concert_id" => concert_id})
  when not is_nil(concert_id) do
    conn
  end

  def create(conn, _) do
    failed_booking(conn)
  end

  defp failed_booking(conn) do
    conn
    |> put_flash(:error, "Something got wrong")
    |> redirect(to: concert_path(conn, :index))
    |> halt()
  end
end
