class StripeController < ApplicationController
  def handle_redirect
    if params[:error] == "access_denied" && params[:error_description] == "The user denied your request"
      redirect_to profile_path
    end

    if params[:code]
      require 'net/http'
      require "uri"

      url = URI.parse('https://connect.stripe.com/oauth/token')

      post_params = {}
      post_params[:client_secret] = ENV['STRIPE_SECRET_KEY']
      post_params[:code] = params[:code]
      post_params[:grant_type] = "authorization_code"

      response = Net::HTTP.post_form(url, post_params)
      response_json = JSON.parse(response.body)

      if response_json["access_token"]
        current_user.update_columns(
          stripe_access_token: response_json["access_token"],
          stripe_publishable_key: response_json["stripe_publishable_key"]
        )
        flash[:success] = "You have successfully connected to Stripe."
      elsif response_json["error"]
        flash[:error] = response_json["error_description"]
      end

      redirect_to profile_path
    end
  end
end