class Api::V1::ConsentsController < ActionController::API
  before_action :authenticate_token

  def show
    @consent = Consent.find_by!(token_id: params[:token_id])
    
    render json: {
      id: @consent.id,
      token_id: @consent.token_id,
      created_at: @consent.created_at,
      signature_url: url_for(@consent.signature)
    }
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Consent not found" }, status: :not_found
  end

  private

  def authenticate_token
    token = request.headers["X-Api-Token"]
    # For POC purposes, we'll use a hardcoded token. In production, this would be in credentials or a database.
    expected_token = "secret-api-token"
    
    unless token == expected_token
      render json: { error: "Unauthorized" }, status: :unauthorized
    end
  end
end
