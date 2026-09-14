require "test_helper"

class Api::V1::ConsentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @consent = Consent.new(token_id: "api-test-token")
    @consent.signature.attach(
      io: File.open(Rails.root.join("test/fixtures/files/test_signature.png")),
      filename: "test_signature.png",
      content_type: "image/png"
    )
    @consent.save!
    @api_token = "secret-api-token"
  end

  test "should get consent by token_id with valid api token" do
    get "/api/v1/consents/#{@consent.token_id}", headers: { "X-Api-Token" => @api_token }
    assert_response :success
    
    json_response = JSON.parse(response.body)
    assert_equal @consent.token_id, json_response["token_id"]
    assert_not_nil json_response["signature_url"]
    assert_not_nil json_response["created_at"]
  end

  test "should return unauthorized with invalid api token" do
    get "/api/v1/consents/#{@consent.token_id}", headers: { "X-Api-Token" => "wrong-token" }
    assert_response :unauthorized
    
    json_response = JSON.parse(response.body)
    assert_equal "Unauthorized", json_response["error"]
  end

  test "should return unauthorized without api token" do
    get "/api/v1/consents/#{@consent.token_id}"
    assert_response :unauthorized
  end

  test "should return not found for non-existent token_id" do
    get "/api/v1/consents/non-existent", headers: { "X-Api-Token" => @api_token }
    assert_response :not_found
    
    json_response = JSON.parse(response.body)
    assert_equal "Consent not found", json_response["error"]
  end
end
