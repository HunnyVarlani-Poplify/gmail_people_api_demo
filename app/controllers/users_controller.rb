require "google/apis/gmail_v1"
require 'google/apis/people_v1'
require 'google/apis/cloudsearch_v1'
require "googleauth"
require "googleauth/stores/file_token_store"
require "fileutils"

class UsersController < ApplicationController
  def link_gmail
    client = Signet::OAuth2::Client.new(client_options)

    redirect_to client.authorization_uri.to_s
  end

  private

  def client_options
    {
      client_id: Rails.application.credentials.dig(:google, :client_id),
      client_secret: Rails.application.credentials.dig(:google, :client_secret),
      authorization_uri: 'https://accounts.google.com/o/oauth2/auth',
      token_credential_uri: 'https://accounts.google.com/o/oauth2/token',
      scope: Google::Apis::PeopleV1::AUTH_CONTACTS,
      redirect_uri: google_webhook_url
    }
  end
end
