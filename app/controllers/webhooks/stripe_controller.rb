module Webhooks
  class StripeController < ApplicationController
    skip_before_action :require_authentication
    skip_forgery_protection

    def create
      payload = request.body.read
      sig_header = request.env["HTTP_STRIPE_SIGNATURE"]
      endpoint_secret = Rails.application.credentials.dig(:stripe, :webhook_secret)

      begin
        event = if endpoint_secret.present?
          Stripe::Webhook.construct_event(payload, sig_header, endpoint_secret)
        else
          JSON.parse(payload, symbolize_names: true, object_class: OpenStruct)
        end
      rescue JSON::ParserError, Stripe::SignatureVerificationError
        head :bad_request
        return
      end

      case event.type
      when "checkout.session.completed"
        handle_checkout_completed(event.data.object)
      end

      head :ok
    end

    private

    def handle_checkout_completed(checkout_session)
      OrderCreationService.new(checkout_session).call
    end
  end
end
