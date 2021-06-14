class AuthController < ApplicationController
  def redirect
    client.code = params[:code]

    response = client.fetch_access_token!

    current_user.update(google_auth: response)
    redirect_to root_path
  end

  private

  def client_options
    {
      client_id: Rails.application.credentials.dig(:google, :client_id),
      client_secret: Rails.application.credentials.dig(:google, :client_secret),
      authorization_uri: 'https://accounts.google.com/o/oauth2/auth',
      token_credential_uri: 'https://accounts.google.com/o/oauth2/token',
      scope: Google::Apis::GmailV1::AUTH_SCOPE,
      redirect_uri: google_webhook_url
    }
  end

  def client
    @client ||= Signet::OAuth2::Client.new(client_options)
  end
end
