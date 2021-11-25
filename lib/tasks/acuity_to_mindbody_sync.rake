# frozen_string_literal: true

namespace :acuity_to_mindbody do
  desc 'Syncs data from Acuity to Mindbody'
  task sync: :environment do
    require 'google/apis/sheets_v4'
    require 'googleauth'

    if ActiveModel::Type::Boolean.new.cast(Setting.acuity_to_mindbody_sync_enabled.value)
      zendesk = Zendesk.new
      zendesk_stage = ZendeskStage.find_by(position: 2)
      Rails.logger.info('[ACUITY] Fetching appointments')
      acuity = Acuity::Appointments.new
      acuity_appointments = acuity.all.body
      Rails.logger.info('[ACUITY] Finished fetching appointments')
      Rails.logger.info('[MINDBODY] Scheduling classes')
      mindbody_clients = Mindbody::Clients.new
      mindbody_classes = Mindbody::GymClasses.new
      acuity_appointments.each do |acuity_appointment|
        # Get Mindbody Client
        mindbody_client = mindbody_clients.where({ SearchText: acuity_appointment.email.downcase }).first
        # Create mindbody client if needed
        # BirthDate is not required on their client config but the API is
        # still requiring it for some reason. We are defaulting it to epoch
        if mindbody_client.nil?
          mindbody_client = begin
                              mindbody_clients.create({
                                                        FirstName: acuity_appointment.firstName,
                                                        LastName: acuity_appointment.lastName,
                                                        Email: acuity_appointment.email.downcase,
                                                        MobilePhone: acuity_appointment.phone,
                                                        BirthDate: Time.zone.at(0).to_s,
                                                        ReferredBy: 'Acuity'
                                                      })
                            rescue Faraday::ClientError => e
                              errors = OpenStruct.new(JSON.parse(e.response[:body])['Error'])
                              Rails.logger.error("[MINDBODY] #{errors.Message} | #{acuity_appointment}")
                              next
                            end
        end
        # Get Mindbody Class
        start_date_time = acuity_appointment.datetime
        next if DateTime.parse(start_date_time).past?

        end_date_time = (DateTime.parse(acuity_appointment.datetime) + 1.hour).strftime('%FT%T%:z')
        classes = mindbody_classes.where({
                                           StartDateTime: start_date_time,
                                           EndDateTime: end_date_time
                                         })
        # Log error if no classes found
        if classes.empty?
          Rollbar.error('Classes not found',
                        start_date_time: start_date_time,
                        end_date_time: end_date_time,
                        acuity_appointment_id: acuity_appointment.id)
          next
        end

        gym_class = classes.first
        # Save Appointment for later use with notifications
        # Skip if we already have the appointment.
        # Mindbody API doesn't have a search for their response from creating a
        # class so we can't lookup via their API if the user has already signed up
        appointment = Appointment.find_by(
          acuity_appointment_id: acuity_appointment.id,
          mindbody_class_id: gym_class.Id
        )
        if appointment.present?
          # Make sure the lead is past the first stage
          lead = Lead.find_by(email: acuity_appointment.email.downcase)
          if lead.nil?
            begin
              lead_service = LeadService.new(
                name: "#{acuity_appointment.firstName} #{acuity_appointment.last_name}",
                phone: acuity_appointment.phone,
                email: acuity_appointment.email,
                referred_by: 'Acuity'
              )
              lead = lead_service.create_lead
            rescue Faraday::ClientError, Google::Apis::ClientError, Google::Apis::AuthorizationError, BaseCRM::ErrorsCollection => e
              Rails.logger.error("[ACUITY TO MINDBODY] Error sending data to third parties. #{acuity_appointment.firstName} #{acuity_appointment.last_name}, #{acuity_appointment.phone}, #{acuity_appointment.email}, #{e}")
              next
            end
          end
          next if lead.zendesk_stage != ZendeskStage.find_by(position: 1)

          begin
            zendesk_deal = lead.zendesk
          rescue BaseCRM::ErrorsCollection => e
            Rails.logger.error(e)
            next
          end
          zendesk_deal.stage_id = zendesk_stage.zendesk_id.to_i
          zendesk.client.deals.update(zendesk_deal)
          if lead.update(zendesk_stage: zendesk_stage)
            # Cancel any current runs
            lead.cancel_current_runs
            # Start a new run via flow
            lead.async_enter_flow
          end

          next
        end

        begin
          mindbody_classes.add_client_to_class(mindbody_client.Id, gym_class.Id)
        rescue Faraday::ClientError => e
          Rails.logger.error(e.response)
          next
        end
        Appointment.create!(
          email: mindbody_client.Email,
          acuity_appointment_id: acuity_appointment.id,
          mindbody_class_id: gym_class.Id,
          starts_at: DateTime.parse(acuity_appointment.datetime)
        )
        # Move lead to second zendesk phase
        lead = Lead.find_by(email: acuity_appointment.email.downcase)
        # Update zendesk stage
        begin
          zendesk_deal = lead.zendesk
        rescue BaseCRM::ErrorsCollection => e
          Rails.logger.error(e)
          next
        end
        zendesk_deal.stage_id = zendesk_stage.zendesk_id.to_i
        zendesk.client.deals.update(zendesk_deal)
        next unless lead.update(zendesk_stage: zendesk_stage)

        # Cancel any current runs
        lead.cancel_current_runs
        # Start a new run via flow
        lead.async_enter_flow
      end
      Rails.logger.info('[MINDBODY] Finished scheduling classes')
    else
      Rails.logger.warn('[ACUITY TO MINDBODY] Disabled via admin.')
    end
  end
end
