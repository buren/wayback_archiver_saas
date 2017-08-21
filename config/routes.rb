require 'sidekiq/web'

Sidekiq::Web.set :sessions, domain: 'all'
Sidekiq::Web.session_secret = Rails.application.secrets[:secret_key_base]
Sidekiq::Web.use Rack::Auth::Basic do |username, password|
  if Rails.env.development?
    true
  else
    # Protect against timing attacks:
    # - See https://codahale.com/a-lesson-in-timing-attacks/
    # - See https://thisdata.com/blog/timing-attacks-against-string-comparison/
    # - Use & (do not use &&) so that it doesn't short circuit.
    # - Use digests to stop length information leaking
    Rack::Utils.secure_compare(::Digest::SHA256.hexdigest(username), ::Digest::SHA256.hexdigest(ENV.fetch('ADMIN_EMAIL'))) &
    Rack::Utils.secure_compare(::Digest::SHA256.hexdigest(password), ::Digest::SHA256.hexdigest(ENV.fetch('ADMIN_PASSWORD')))
  end
end

Rails.application.routes.draw do
  mount Sidekiq::Web, at: 'sidekiq'

  root to: 'page#home'

  resources :archivations, only: %i(new create show) do
    collection do
      get '/', action: :new
    end
  end

  get '/ping', to: 'archivations#ping'
end
