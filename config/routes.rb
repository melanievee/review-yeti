ReviewYeti::Application.routes.draw do
  get 'account_activations/edit'

  require 'sidekiq/web'
  require 'sidetiq/web'
  root 'static_pages#home'
  
  get    'profile'        => 'users#show'
  get    'profile/edit'   => 'users#edit'
  get    '/signup'        => 'users#new'
  get    '/signin'        => 'sessions#new'
  post   '/signin'        => 'sessions#create'
  delete '/signout'       => 'sessions#destroy'
  get    '/features'      => 'static_pages#features'
  get    '/contact'       => 'static_pages#contact'
  get    '/rankings'      => 'static_pages#rankings'

  resources :users #Need to remove index? destroy?
  resources :sessions, only: [:new, :create, :destroy]
  resources :apps do 
    member do 
      get 'rankings'
      get 'reviews'
    end
  end
  resources :relationships, only: [:create, :destroy]
  resources :account_activations, only: [:edit]
  
  mount Sidekiq::Web, at: '/sidekiq'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
