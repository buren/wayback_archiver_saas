require 'sidekiq/web'

Sidekiq::Web.set :sessions, domain: 'all'
Sidekiq::Web.session_secret = Rails.application.secrets[:secret_key_base]
Sidekiq::Web.use Rack::Auth::Basic do |username, password|
  if Rails.env.development?
    true
  else
    username == ENV.fetch('ADMIN_EMAIL') && password == ENV.fetch('ADMIN_PASSWORD')
  end
end

Rails.application.routes.draw do
  mount Sidekiq::Web, at: 'sidekiq'

  resources :archivations, only: %i(create show)

  get '/ping', to: 'archivations#ping'
end
