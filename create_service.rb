require 'twilio-ruby'
require 'psych'

settings = Psych.load(File.read('config.yml'))

# Authenticate with Twilio
client = Twilio::REST::Client.new settings['TWILIO_ACCOUNT_SID'], settings['TWILIO_AUTH_TOKEN']

# Create a user notification service instance
serviceData = {friendly_name: 'My First Notifications App'}

if settings['TWILIO_APN_CREDENTIAL_SID'] 
  serviceData[:apn_credential_sid] = settings['TWILIO_APN_CREDENTIAL_SID']
  puts "Adding APN Credentials to service"
else
  puts "No APN Credentials configured - add in config.yml, if available."
end

if settings['TWILIO_GCM_CREDENTIAL_SID']
  serviceData[:gcm_credential_sid] = settings['TWILIO_GCM_CREDENTIAL_SID']
  puts "Adding GCM Credentials to service"
else
  puts "No GCM Credentials configured - add in config.yml, if available."
end

service = client.notifications.v1.services.create(serviceData)
puts service