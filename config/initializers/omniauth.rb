Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, ENV['FACEBOOK_KEY'] , ENV['FACEBOOK_SECRET'] , callback_url: ENV['FACEBOOK_CALLBACK_URL']
  provider :google_oauth2, ENV['GOOGLE_CLIENT_ID'], ENV['GOOGLE_CLIENT_SECRET'], {
    scope: 'email, profile, plus.me',
    :client_options => { :ssl => { :ca_file => 'C:\Ruby21\cacert.pem'}},
    provider_ignores_state: true,
    redirect_uri: 'http://localhost:3000/users/auth/google_oauth2/callback/',
    prompt: 'select_account',
    image_aspect_ratio: 'square',
    image_size: 50,
    setup: (lambda do |env|
      request = Rack::Request.new(env)
      env['omniauth.strategy'].options['token_params'] = {
        redirect_uri: 'http://localhost:3000/auth/google_oauth2/callback/'
      }
    end)
  }
end
