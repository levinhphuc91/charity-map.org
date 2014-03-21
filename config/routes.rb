CharityMap::Application.routes.draw do
  resources :categories

  get   'users/dashboard'
  get   'users/profile'
  get   'users/settings'
  get   'users/follow'
  get   'users/messages', as: :messages
  get   'users/donations'
  get   'users/gift_cards'
  get   'users/verify'
  post  'users/update_settings'
  post  'users/add_figure_to_portfolio'
  get   'users/delete_figure_from_portfolio'
  post  'users/add_ext_project_to_portfolio'
  post  'users/delete_ext_project_from_portfolio'
  post  'users/verification_code_via_phone'
  get   'users/resend_verification'
  get   'users/verification_delivery_receipt'
  get   'user/:id', to: 'users#profile', as: :user_profile
  get   'donations/request_verification/:euid', to: 'donations#request_verification', as: :request_verification
  get   'donations/confirm', to: 'donations#confirm', as: :confirm_donation
  match 'dashboard', to: 'users#dashboard', via: :all, as: :dashboard
  post  'users/fbnotif'
  post  'users/redeem_gift_card'
  match 'fbnotif/:token', to: 'users#fbnotif', via: :all
  match '/', to: 'users#fbnotif', via: :post
  
  devise_for :users, :controllers => {
    :omniauth_callbacks => "users/omniauth_callbacks",
    :registrations => "registrations",
    :sessions => "sessions"
  }

  get   'pages/home'
  get   'pages/about'
  get   'pages/faqs'
  get   'pages/guidelines'
  get   'gifts', to: 'pages#gifts'
  get   'donations/request_verification'

  resources :projects do
    collection do
      get 'autocomplete'
      get 'search'
      get 'invite_ext_donor'
    end
    get   'submit', on: :member
    resources :invites do
      get 'send_out', on: :collection
      post 'import', on: :collection
    end
    resources :ext_donations
    resources :project_rewards
    resources :donations do
      post 'add_ext_donation', on: :collection
    end
    resources :project_comments
    resources :project_updates
    resources :recommendations
    resources :project_follows do
      get 'initiate', on: :collection
    end
  end

  namespace :dashboard do
    resources :projects do
      get 'members', on: :member
      post 'add_member', on: :member
      delete 'remove_member', on: :member
    end
    resources :gift_cards
  end

  namespace :admin do
    get 'pages/projects'
    get 'pages/donations'
    get 'pages/users'
    get 'pages/updates'
    get 'pages/edit_donation'
    post 'pages/update_donation'
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
  match ':short_code', to: 'projects#abbr', via: :all

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