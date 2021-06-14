class HomeController < ApplicationController
  def index; end

  def redirect
    client.code = params[:code]
    @tokens = client.fetch_access_token!
    
    service = Google::Apis::PeopleV1::PeopleServiceService.new
    service.client_options.application_name = 'Test'
    service.authorization = client

    # Fetch the next 10 events for the user
    # response = service.list_person_connections(
    #   "people/me",
    #   page_size:     10,
    #   person_fields: "names,emailAddresses"
    # )
    client_data = Google::Apis::PeopleV1::ClientData.new(key: 'KEY1',value: 'VALUE1')
    cg = Google::Apis::PeopleV1::ContactGroup.new(name: 'Test CG', client_data: client_data)
    contact_group = Google::Apis::PeopleV1::CreateContactGroupRequest.new(contact_group: cg)
    response = service.create_contact_group(contact_group)
    
    ## Get Contact Group
    contact_group = service.get_contact_group(response.resource_name)
    binding.pry

    # ## Update Contact Group
    # # contact_group = service.update_contact_group(response.resource_name)
    
    # ## Modify Group members in Contact Group
    # resource_names = [response.resource_name]
    # members_group = Google::Apis::PeopleV1::ModifyContactGroupMembersRequest.new()
    # contact_group = service.modify_contact_group_members(response.resource_name, resource_names)
    # ## Get ALL contact groups
    # contact_groups = service.list_contact_groups()

    ## Delete Contact Group
    # contact_group = service.delete_contact_group(response.resource_name)

    # ## List other contacts 
    # other_contacts = service.list_other_contacts()


    
    ## Create a new person account
      person_object = Google::Apis::PeopleV1::Person.new(names: [
          {
              given_name: "HunnyYashVarlani"
            }
          ],
          email_addresses: [
              {
                  value: "hunny@varlani.com"
                }
              ],
              phone_numbers: [
                  {
                      value: "12345678"
                  }
                ],
                memberships: [
                  {
                    contact_group_membership: {
                      contact_group_resource_name: response.resource_name
                    }
                  }
                ])
                
                binding.pry
                
                p1 = service.create_person_contact(person_object)
                
    # ## Get Contact or Person
    # p1 = service.get_person('people/c7368206141695667438', 
    #   person_fields: "names,emailAddresses")
    # p1.names = [{given_name: 'HunnyYashVarlani'}]

    # ## Update a contact
    # p1 = service.update_person_contact('people/c7368206141695667438', p1, update_person_fields: "names,emailAddresses")

    ## Delete the contact
    # deleted_contact = service.delete_person_contact('people/c7368206141695667438')

    
    # contacts_user = GoogleContactsApi::User.new(client.access_token)
    # # when you do mail.to_s it forms a raw email text string which you can supply to the raw argument of Message object
    # message_to_send = Google::Apis::GmailV1::Message.new(raw: mail.to_s, thread_id: thread_id)
    # # @service is an instance of Google::Apis::GmailV1::GmailService
    # response = service.send_user_message("me", message_to_send)
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

  def client
    @client ||= Signet::OAuth2::Client.new(client_options)
  end
end
