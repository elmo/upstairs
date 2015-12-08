Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, ENV['FACEBOOK_KEY'] , ENV['FACEBOOK_SECRET'], callback_url: ENV['FACEBOOK_CALLBACK_URL']
  provider :google_oauth2, ENV['GOOGLE_CLIENT_ID'], ENV['GOOGLE_CLIENT_SECRET'],
      {
	:name => "google",
	:scope => "email, profile",
	:prompt => "select_account",
	:image_aspect_ratio => "square",
	:image_size => 50,
	:callback_url => ENV['GOOGLE_CLIENT_CALLBACK_URL']
      }
end
OmniAuth.config.full_host = Rails.env.production? ? 'http://www.upstairs.io' : 'http://localhost:3000'
