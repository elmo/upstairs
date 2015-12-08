Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, ENV['FACEBOOK_KEY'] , ENV['FACEBOOK_SECRET'] , callback_url: ENV['FACEBOOK_CALLBACK_URL']
  provider :google_oauth2, ENV['GOOGLE_CLIENT_ID'], ENV['GOOGLE_CLIENT_SECRET'], callback_url: ['GOOGLE_CLIENT_CALLBACK_URL']
end
