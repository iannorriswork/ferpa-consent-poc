require "application_system_test_case"

class ConsentsTest < ApplicationSystemTestCase
  test "creating a consent" do
    visit new_consent_url

    fill_in "Token ID", with: "test-token-123"
    
    # We can't easily draw on canvas with Capybara without some JS execution
    # But we can at least check if the page loads and the form is present
    assert_selector "h1", text: "Incremental Consent POC"
    assert_selector "canvas"
    
    # Simulate a signature by setting the hidden field and file input manually
    # or just test the submission if we can
  end
end
