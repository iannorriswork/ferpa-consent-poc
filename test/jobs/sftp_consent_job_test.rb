require "test_helper"
require "net/sftp"

class SftpConsentJobTest < ActiveJob::TestCase
  setup do
    @consent = Consent.new(token_id: "test-token")
    @consent.signature.attach(io: File.open(Rails.root.join("test/fixtures/files/test_signature.png")), filename: "test_signature.png", content_type: "image/png")
    @consent.save!
    
    # Enable SFTP for tests
    Rails.application.config.sftp_consent.enabled = true
  end

  test "uploads file via SFTP when enabled" do
    # Simple mock using a Struct or object
    mock_session = Object.new
    class << mock_session
      attr_accessor :uploaded
      def upload!(local, remote)
        self.uploaded = true
      end
    end

    # Use Minitest::Spec style stubbing on the singleton class or just re-define the method
    Net::SFTP.instance_eval do
      class << self
        alias_method :original_start, :start
        def start(host, user, options, &block)
          block.call(@mock_session)
        end
        attr_accessor :mock_session
      end
    end
    
    Net::SFTP.mock_session = mock_session
    begin
      SftpConsentJob.perform_now(@consent.id)
    ensure
      Net::SFTP.instance_eval do
        class << self
          alias_method :start, :original_start
          remove_method :original_start
          remove_method :mock_session
        end
      end
    end

    assert mock_session.uploaded
  end

  test "does not upload if disabled" do
    Rails.application.config.sftp_consent.enabled = false
    
    # If Net::SFTP.start is called, it will crash because we haven't stubbed it here
    SftpConsentJob.perform_now(@consent.id)
    assert true
  end
end
