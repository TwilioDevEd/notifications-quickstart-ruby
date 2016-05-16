require 'sinatra'
require 'twilio-ruby'
require 'psych'

settings = Psych.load(File.read('config.yml'))


# Basic health check - check environment variables have been configured
# correctly
get '/' do
  erb :index, locals: {settings: settings}
end

post '/register' do
  # Authenticate with Twilio
  client = Twilio::REST::Client.new settings['TWILIO_ACCOUNT_SID'], settings['TWILIO_AUTH_TOKEN']
  
  # Reference a valid notification service
  service = client.notifications.v1.services(settings['TWILIO_NOTIFICATION_SERVICE_SID'])
  
  begin 
    binding = service.bindings.create(
      endpoint: params[:endpoint],
      identity: params[:identity],
      binding_type: params[:BindingType],
      address: params[:Address],
    )
    response = {message: 'Binding created!' }
    response.to_json
  rescue Twilio::REST::TwilioException => e
    status 500
      response = {
        message: "Failed to create binding: #{e.message}",
        error: e
      }
      response.to_json
  end
end

