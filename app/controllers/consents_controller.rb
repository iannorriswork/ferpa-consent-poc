class ConsentsController < ApplicationController
  def new
    @consent = Consent.new
    if params[:embedded] == "true"
      response.headers.delete "X-Frame-Options"
      # In development, the test server might run on a random port, so we use a more permissive CSP or allow the current origin
      response.headers["Content-Security-Policy"] = "frame-ancestors 'self' http://localhost:* http://127.0.0.1:*"
      render layout: "embedded"
    end
  end

  def create
    @consent = Consent.new(consent_params)

    if @consent.save
      if params[:embedded] == "true"
        render plain: "<html><body><script>window.parent.postMessage({type: 'consent_success'}, '*');</script></body></html>", content_type: "text/html"
      else
        redirect_to @consent, notice: "Consent was successfully uploaded."
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @consent = Consent.find(params[:id])
  end

  private

  def consent_params
    params.require(:consent).permit(:token_id, :signature)
  end
end
