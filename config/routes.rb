Rails.application.routes.draw do

  resources :uploads, only: [:new] do
    collection do
      scope '/', defaults: { format: :json } do
        post '/' => 'uploads#create'
        post '/sign' => 'uploads#sign'
        delete '/:uuid' => 'uploads#destroy'
      end
    end
    root 'uploads#new'
  end

  root 'uploads#new'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
