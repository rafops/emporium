Rails.application.routes.draw do

  scope '/uploads' do
    get '/' => 'uploads#index'
    post '/sign' => 'uploads#sign'
    post '/complete' => 'uploads#complete'
    delete '/:uuid' => 'uploads#destroy'
  end

  root 'uploads#index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
