use actix_web::dev::Server;
use actix_web::{web, App, HttpServer};
use std::net::TcpListener;
pub mod routes;

pub fn run(listener: TcpListener) -> Result<Server, std::io::Error> {
    let server = HttpServer::new(|| {
        App::new()
            .route("/health_check", web::get().to(routes::health_check))
            .route("/subscriptions", web::post().to(routes::subscriptions))
    })
    .listen(listener)?
    .run();
    // No .await here!
    Ok(server)
}
