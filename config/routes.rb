Rails.application.routes.draw do

  resources :uploads, only: [:new, :create] do
    collection do
      post '/sign' => 'uploads#sign'
      delete '/:uuid' => 'uploads#destroy'
    end
    root 'uploads#new'
  end

  root 'uploads#new'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
