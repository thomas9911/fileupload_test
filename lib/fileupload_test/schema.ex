defmodule FileuploadTest.Schema do
  use Absinthe.Schema

  import_types(Absinthe.Plug.Types)
  import_types(FileuploadTest.Schema.Stuff)

  query do
    @desc "Get all posts"
    field :posts, list_of(:post) do
      resolve(&FileuploadTest.Resolvers.Stuff.list_posts/3)
    end
  end

  mutation do
    field :upload_file, :string do
      arg(:file, non_null(:upload))

      resolve(&FileuploadTest.Resolvers.Stuff.upload_file/3)
    end
  end

  # curl -X POST -F query="mutation { u -F users_csv=@users.csv localhost:4001/api

  # sadly absinthe uses non standard file uploads :(
end
