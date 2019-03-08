Rails.application.routes.draw do
  get 'welcome/index'

  root 'static_pages#home'
  get  '/about',   		     	to: 'static_pages#about'
  get  '/contact', 		     	to: 'static_pages#contact'
  get  '/new_model',			to: 'url_data_models#new'

  resources :url_data_models
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
