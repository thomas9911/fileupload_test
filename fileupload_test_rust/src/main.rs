use actix_web::{guard, web, App, HttpResponse, HttpServer};
use async_graphql::http::{playground_source, GraphQLPlaygroundConfig, MultipartOptions};
use async_graphql::{EmptySubscription, Schema};
use async_graphql_actix_web::{Request, Response};

mod schema;
use schema::{FilesSchema, MutationRoot, QueryRoot, Storage};

async fn index(schema: web::Data<FilesSchema>, req: Request) -> Response {
    println!("HEY HEY");
    let a = schema.execute(req.into_inner()).await;

    println!("{:?}", a);

    a.into()
}

async fn gql_playgound() -> HttpResponse {
    HttpResponse::Ok()
        .content_type("text/html; charset=utf-8")
        .body(playground_source(GraphQLPlaygroundConfig::new("/graphql")))
}

#[actix_rt::main]
async fn main() -> std::io::Result<()> {
    let schema = Schema::build(QueryRoot, MutationRoot, EmptySubscription)
        .data(Storage::default())
        .finish();

    println!("Playground: http://localhost:4001");

    HttpServer::new(move || {
        App::new()
            .data(schema.clone())
            .service(
                web::resource("/graphql")
                    .guard(guard::Post())
                    .to(index)
                    // .app_data(MultipartOptions::default().max_num_files(3)),
            )
            .service(web::resource("/").guard(guard::Get()).to(gql_playgound))
    })
    .bind("127.0.0.1:4001")?
    .run()
    .await
}