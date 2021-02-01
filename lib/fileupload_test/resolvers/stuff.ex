defmodule FileuploadTest.Resolvers.Stuff do

  @max_size 1_000_000
  @allowed_types ["image/png"]
  @base_path "priv/static/"

  def list_posts(_, _, _) do
    {
      :ok,
      [
        %{
          id: 1,
          title: "Oke",
          body: "bla"
        },
        %{
          id: 2,
          title: "Oke2",
          body: "bla"
        },
        %{
          id: 3,
          title: "Oke3",
          body: "bla"
        }
      ]
    }
  end

  def upload_file(_, %{file: file}, _) do
    IO.inspect(file)

    # {:ok, "yes"}
    file |> file_info() |> save()
  end

  def upload_file(_, _, _) do
    {:error, "nej"}
  end

  defp file_info(%{path: path} = file) do
    %{size: size} = path |> File.stat!()

    file
    |> Map.from_struct()
    |> Map.put(:size, size)
  end


  def save(%{size: size} = file_info) when size > @max_size do
    {:error, :too_large}
  end

  def save(%{content_type: content_type} = file_info) when content_type not in @allowed_types do 
    {:error, :invalid_type}
  end

  def save(%{path: path, filename: filename} = file_info) do
    name = slugify(filename)

    to_path = "images/#{name}"

    case File.cp(path, @base_path <> to_path) do
      :ok -> {:ok, to_path}
      err -> err
    end
  end

  # defp slugify(name), do: URI.encode(name)
  defp slugify(name), do: String.replace(name, " ", "+")
end
