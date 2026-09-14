class Consent < ApplicationRecord
  has_one_attached :signature
  validates :token_id, presence: true
  validates :signature, presence: true

  scope :valid, -> { where(invalidated_at: nil) }
  scope :invalid, -> { where.not(invalidated_at: nil) }

  after_create_commit :enqueue_sftp_upload

  private

  def enqueue_sftp_upload
    SftpConsentJob.perform_later(self.id) if Rails.application.config.sftp_consent.enabled
  end
end
