Rails.application.routes.draw do

  devise_for :users, controllers: {
    sessions: 'users/sessions'
  }

  resources :uploads, only: [] do
    collection do
      scope '/', defaults: { format: :json } do
        post '/sign' => 'uploads#sign'
      end
    end
  end

  resources :photos, only: [:new] do
    collection do
      scope '/', defaults: { format: :json } do
        post   '/'      => 'photos#create'
        delete '/:uuid' => 'photos#destroy'
      end
    end
    root 'photos#new'
  end

  resources :events, only: [:index, :create], defaults: { format: :json } do
    collection do
      scope '/' do
        get '/:uuid' => 'events#show', as: :show, defaults: { format: :html }
      end
    end
  end

  root 'home#index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
