require "application_system_test_case"

class DemoTest < ApplicationSystemTestCase
  test "visiting the demo page and seeing the embedded form" do
    visit demo_url
    
    assert_selector "h2", text: "Third-Party Application Demo"
    
    within_frame "consent-iframe" do
      assert_selector "h1", text: "Incremental Consent POC"
      assert_text "By signing below, you authorize the Medicaid agency to access and retrieve your education-related data."
      fill_in "Token ID", with: "demo-token-123"
      
      # Simulate signature by drawing on canvas (or just filling the hidden field if we want to shortcut)
      # For system test, we can use execute_script to set the value and trigger the file upload logic
      # or just interact with the canvas if the driver supports it.
      # Easiest is to set the hidden field and call the submission.
      
      page.execute_script("document.querySelector('[data-signature-target=\"input\"]').value = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z8BQDwAEhQGAhKma4QAAAABJRU5ErkJggg==';")
      
      accept_alert do
        click_on "Upload Consent"
      end
    end

    assert_text "Thank you! Consent has been successfully submitted."
    assert_button "Proceed to Next Step →", disabled: false
  end
end
