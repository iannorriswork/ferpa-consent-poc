Rails.application.configure do
  config.sftp_consent = ActiveSupport::OrderedOptions.new
  
  # Enable/Disable SFTP upload
  config.sftp_consent.enabled = ENV.fetch("SFTP_ENABLED", "false") == "true"
  
  # SFTP Configuration
  config.sftp_consent.host = ENV.fetch("SFTP_HOST", "localhost")
  config.sftp_consent.port = ENV.fetch("SFTP_PORT", 22).to_i
  config.sftp_consent.user = ENV.fetch("SFTP_USER", "user")
  config.sftp_consent.password = ENV.fetch("SFTP_PASSWORD", nil)
  config.sftp_consent.key_path = ENV.fetch("SFTP_KEY_PATH", nil)
  config.sftp_consent.remote_path = ENV.fetch("SFTP_REMOTE_PATH", "/uploads")
end
