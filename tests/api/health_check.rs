use crate::helpers::spawn_app;

#[tokio::test]
async fn health_check_works() {
    // No .await, no .expect
    let app = spawn_app().await;
    let client = reqwest::Client::new();

    // Actual test
    let response = client
        .get(format!("{}/health_check", &app.address))
        .send()
        .await
        .expect("Failed to excute request.");

    // Asserts
    assert!(response.status().is_success());
    assert_eq!(Some(0), response.content_length());
}