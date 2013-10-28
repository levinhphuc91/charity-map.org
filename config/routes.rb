CharityMap::Application.routes.draw do
  get   'users/dashboard'
  get   'users/profile'
  get   'users/settings'
  get   'users/messages', as: :messages
  get   'users/donations'
  get   'users/verify'
  post  'users/update_settings'
  post  'users/verification_code_via_phone'
  get   'users/resend_verification'
  get   'users/verification_delivery_receipt'
  get   'user/:id', to: 'users#profile', as: :user_profile
  get   'donations/request_verification/:euid', to: 'donations#request_verification', as: :request_verification
  get   'donations/confirm', to: 'donations#confirm', as: :confirm_donation
  match 'dashboard', to: 'users#dashboard', via: :all, as: :dashboard
  
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  get   'pages/home'
  get   'pages/about'
  get   'pages/faqs'
  get   'pages/guidelines'

  get   'projects/submit'

  get   'donations/request_verification'

  resources :projects do
    collection do
      get 'autocomplete'
      get 'search'
    end
    resources :project_rewards
    resources :donations
    resources :project_comments
    resources :project_updates
    resources :recommendations
    resources :project_follows do
      get 'initiate', on: :collection
    end
  end

  namespace :dashboard do
    resources :projects
  end

  resources :users, :except => [ :create, :new ] do
    get "show_message", :on => :collection
    get "new_message", :on => :collection
    get "new_reply_message", :on => :collection
    post "create_message", :on => :collection
    post "reply_message", :on => :collection
    resources :store
  end
  
  namespace :api, defaults: {format: 'json'} do
    namespace :v1 do
      get   'metrics/new_signup'
      get   'metrics/latest_recommendation'
      get   'metrics/donation_progress'
      get   'metrics/avg_collection_time'
      get   'metrics/avg_donation_amount'
    end
  end
  
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with 'rake routes'.

  # You can have the root of your site routed with 'root'
  root 'pages#home'

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