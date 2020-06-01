Rails.application.routes.draw do
  root to: 'employees#index'
  resources :employees do
    get 'matching', on: :collection
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
