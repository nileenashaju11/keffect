# frozen_string_literal: true

module Api
  class LeadsController < ApiController
    def create
      ActiveRecord::Base.transaction do
        first_name = client_params.dig(:first)
        last_name = client_params.dig(:last)
        email = client_params.dig(:email)
        phone = client_params.dig(:phone)

        # Save to MindBody
        begin
          find_or_create_in_mindbody
        rescue Faraday::ClientError => e
          Rollbar.error(e)
          return render json: JSON.parse(e.response[:body]), status: e.response[:status]
        end

        # Save to Zendesk Deals
        begin
          zendesk_contact, zendesk_deal, zendesk_stage = find_or_create_in_zendesk
        rescue BaseCRM::ErrorsCollection => e
          Rollbar.error(e,
                        first_name: first_name,
                        last_name: last_name,
                        email: email,
                        mobile: phone)
          errors = e.errors.map(&:details).join
          return render json: errors.to_json, status: e.http_status.to_i
        end

        # Create Lead in database
        Lead.create!(
          name: "#{zendesk_contact.first_name} #{zendesk_contact.last_name}",
          phone_number: zendesk_contact.mobile&.delete('^0-9'),
          email: zendesk_contact.email,
          zendesk_id: zendesk_deal.id,
          zendesk_stage: zendesk_stage
        )

        # Save to Google Sheets
        begin
          send_to_google_sheets
        rescue Google::Apis::ClientError, Google::Apis::AuthorizationError => e
          Rollbar.error(e)
          return render json: e.body.to_json, status: e.status_code
        end
      end
      render json: { status: 'success' }.to_json
    end

    private

    def send_to_google_sheets
      google_sheets = GoogleSheets.new
      google_sheets.append_row(
        first_name: client_params.dig(:first),
        last_name: client_params.dig(:last),
        email: client_params.dig(:email),
        phone: client_params.dig(:phone),
        time: Time.current.to_s
      )
    end

    def find_or_create_in_mindbody
      first_name = client_params.dig(:first)
      last_name = client_params.dig(:last)
      email = client_params.dig(:email)
      phone = client_params.dig(:phone)

      mind_body = Mindbody::Clients.new
      mindbody_client = mind_body.where({ SearchText: email }).first
      # Create mindbody client if needed
      # BirthDate is not required on their client config but the API is
      # still requiring it for some reason. We are defaulting it to epoch
      return mindbody_client if mindbody_client.present?

      # BirthDate is not required on their client config but the API is
      # still requiring it for some reason. We are defaulting it to epoch
      mind_body.create({
                         FirstName: first_name,
                         LastName: last_name,
                         Email: email,
                         MobilePhone: phone,
                         BirthDate: Time.zone.at(0).to_s,
                         ReferredBy: 'KEffectTraining.com'
                       })
    end

    def find_or_create_in_zendesk
      first_name = client_params.dig(:first)
      last_name = client_params.dig(:last)
      email = client_params.dig(:email)
      phone = client_params.dig(:phone)

      zendesk = Zendesk.new
      zendesk_contact = zendesk.client.contacts.where(email: email).first
      # If we can't find the contact we create
      if zendesk_contact.nil?
        zendesk_contact = zendesk.client.contacts.create(
          name: "#{first_name} #{last_name}",
          first_name: first_name,
          last_name: last_name,
          email: email,
          mobile: phone
        )
      end
      # This is the opening deal stage, we assume coming in the API they will start here
      zendesk_stage = ZendeskStage.find_by(position: 1)
      # Create deal for contact
      zendesk_deal = zendesk.client.deals.create(
        name: "#{first_name} #{last_name}",
        contact_id: zendesk_contact.id,
        stage_id: zendesk_stage&.zendesk_id.to_i
      )
      [zendesk_contact, zendesk_deal, zendesk_stage]
    end

    def client_params
      params.require(:lead).permit(
        :first,
        :last,
        :email,
        :phone
      )
    end
  end
end
