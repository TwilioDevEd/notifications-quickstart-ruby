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
end

