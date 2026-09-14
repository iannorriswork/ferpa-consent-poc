require 'net/sftp'

class SftpConsentJob < ApplicationJob
  queue_as :default

  def perform(consent_id)
    consent = Consent.find(consent_id)
    return unless consent.signature.attached?

    config = Rails.application.config.sftp_consent
    return unless config.enabled

    filename = "consent_#{consent.token_id}_#{consent.id}.png"
    local_path = ActiveStorage::Blob.service.path_for(consent.signature.key)

    options = { port: config.port }
    options[:password] = config.password if config.password.present?
    options[:keys] = [config.key_path] if config.key_path.present?

    Net::SFTP.start(config.host, config.user, options) do |sftp|
      remote_full_path = File.join(config.remote_path, filename)
      sftp.upload!(local_path, remote_full_path)
    end
  end
end
