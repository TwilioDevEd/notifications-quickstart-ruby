require 'twilio-ruby'
require 'psych'

settings = Psych.load(File.read('config.yml'))

# Authenticate with Twilio
client = Twilio::REST::Client.new settings['TWILIO_ACCOUNT_SID'], settings['TWILIO_AUTH_TOKEN']

# Create a reference to the user notification service
service_sid = settings['TWILIO_NOTIFICATION_SERVICE_SID']
if service_sid
  service = client.notifications.v1.services(service_sid)
  # Create a notification for a given identity
  identity = ARGV.first
  puts "Sending a notification to identity: #{identity}"
  notification = service.notifications.create(
      identity: identity, 
      body: "Hello #{identity}!"
  )
  puts notification
else
  puts 'Please put a SID for a valid notification service in config.yml'
end