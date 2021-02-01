defmodule FileuploadTest.Rest do
  use Plug.Builder

  alias Plug.Conn

  plug(:test)

  def test(
        %{
          method: "POST",
          body_params: %{
            "file" => upload_obj
          }
        } = conn,
        _
      ) do
    IO.inspect(upload_obj)
    File.read!(upload_obj.path) |> IO.inspect()

    Conn.send_resp(conn, 200, "Thx for uploading!!!")
  end

  def test(conn, _) do
    Conn.send_resp(conn, 200, nice_html())
  end

  defp nice_html do
    """
    <div>
      <form method="post" enctype="multipart/form-data">
        <div>
          <label for="file">Choose file to upload</label>
          <input type="file" id="file" name="file" multiple />
        </div>
        <div>
          <button>Submit</button>
        </div>
      </form>
    </div>
    """
  end
end
