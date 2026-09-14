require "application_system_test_case"

class AdminConsentsTest < ApplicationSystemTestCase
  setup do
    @admin = User.create!(email: "admin@example.com", password: "password", admin: true)
    @consent1 = Consent.new(token_id: "token-123")
    @consent1.signature.attach(io: File.open(Rails.root.join("test/fixtures/files/test_signature.png")), filename: "sig1.png", content_type: "image/png")
    @consent1.save!

    @consent2 = Consent.new(token_id: "other-456")
    @consent2.signature.attach(io: File.open(Rails.root.join("test/fixtures/files/test_signature.png")), filename: "sig2.png", content_type: "image/png")
    @consent2.save!
  end

  test "admin can log in and see consents" do
    visit login_url
    fill_in "Email", with: @admin.email
    fill_in "Password", with: "password"
    click_on "Login"

    assert_text "Admin - Consent Management"
    assert_text "token-123"
    assert_text "other-456"
  end

  test "admin can search for consent by token" do
    visit login_url
    fill_in "Email", with: @admin.email
    fill_in "Password", with: "password"
    click_on "Login"

    fill_in "Search by Token ID:", with: "token-123"
    click_on "Search"

    assert_text "token-123"
    assert_no_text "other-456"
  end

  test "admin can mark a consent as invalid" do
    visit login_url
    fill_in "Email", with: @admin.email
    fill_in "Password", with: "password"
    click_on "Login"

    within "tr", text: "token-123" do
      click_on "Mark Invalid"
    end

    assert_text "Consent marked as invalid."
    within "tr", text: "token-123" do
      assert_text "Invalidated at"
      assert_no_button "Mark Invalid"
    end
  end
end
