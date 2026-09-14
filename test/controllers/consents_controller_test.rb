require "test_helper"

class ConsentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @consent = Consent.new(token_id: "test-token")
    @consent.signature.attach(io: File.open(Rails.root.join("test/fixtures/files/test_signature.png")), filename: "test_signature.png", content_type: "image/png")
    @consent.save!
  end

  test "should get new" do
    get new_consent_url
    assert_response :success
  end

  test "should create consent" do
    assert_difference("Consent.count") do
      post consents_url, params: { 
        consent: { 
          token_id: "new-token", 
          signature: fixture_file_upload("test_signature.png", "image/png") 
        } 
      }
    end

    assert_redirected_to consent_url(Consent.last)
  end

  test "should show consent" do
    get consent_url(@consent)
    assert_response :success
  end
end
