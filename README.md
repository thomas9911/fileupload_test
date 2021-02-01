# Finds

## Requirements

- File upload
- FusionAuth authentication (https://fusionauth.io/docs/v1/tech/apis/jwt/#validate-a-jwt)
- File upload to Microsoft Blob storage (?)

## apps

### react
app folder contains the react frontend

### elixir
lib contains the elixir code

### python
fileupload_test contains the python code

### node
src contains the node code



## Frontend

### Apollo upload client

type: GraphQL
lang: Elixir
link: https://github.com/jaydenseric/apollo-upload-client

#### pos

- default for apollo

#### neg

- no default implementation in absinthe

## Backend

### Absinthe Upload type

type: GraphQL
lang: Elixir

#### pos

- default for absinthe

#### neg

- non standard implementation, so we need a special apollo-link for it (https://www.npmjs.com/package/apollo-absinthe-upload-link)

### Standard Cowboy Plug.Upload

type: REST
lang: Elixir

#### pos

- simple implementation, backend and frontend (works even with default html file input)

#### neg

- not GraphQL, so we need to implement this seperatly from Apollo

### Absinthe Upload type with extra Absinthe.Upload plug

type: GraphQL
lang: Elixir
link: https://hexdocs.pm/absinthe_upload/Absinthe.Upload.html

#### pos

- default apollo implementation
- works with Plug.Upload type

#### neg

- not a very popular elixir lib, but it also does not do very much.
- lib mix.exs says it only supports elixir >= 1.11, but i think that is not true.

### Graphene File upload

type: GraphQL
lang: python

#### pos

- straight forward
- azure native library for file uploads

#### neg

- python, so new eco system

### Express Node JS

type: GraphQL
lang: node js/ts

#### pos

- straight forward

#### neg

- node
