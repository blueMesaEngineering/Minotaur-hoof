Rails.application.routes.draw do
  
  root 'static_pages#home'
  get  '/about',   		     	to: 'static_pages#about'
  get  '/contact', 		     	to: 'static_pages#contact'
  get  '/test',             to: 'static_pages#test'
  get  '/new_model',			  to: 'url_data_models#new'
  get  '/serializedJSON',   to: 'static_pages#serializedJSON'

  resources :url_data_models
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end