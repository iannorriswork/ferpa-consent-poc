class Admin::ConsentsController < ApplicationController
  before_action :require_admin

  def index
    @consents = Consent.all
    if params[:token_id].present?
      @consents = @consents.where("token_id LIKE ?", "%#{params[:token_id]}%")
    end
    @consents = @consents.order(created_at: :desc)
  end

  def invalidate
    @consent = Consent.find(params[:id])
    @consent.update(invalidated_at: Time.current)
    redirect_to admin_consents_path, notice: "Consent marked as invalid."
  end
end
