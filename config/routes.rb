Rails.application.routes.draw do

  get 'news/index'

  get 'news/show'

  get 'news/destroy'

  require 'sidekiq/web'
  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
  username == "1qa2ws3ed" && password == "1qa2ws3ed"
  end if Rails.env.production?
  mount Sidekiq::Web, at: "/sidekiq"

  root "main_pages#start"
  resources :sessions, only: [:create, :destroy, :index]
  resources :organizations do
    member do
      post "invite" => "organizations#join_to_organization", as: :join_to
    end
  end
  resources :users do
    resources :tasks do
      patch 'handle_task', on: :member, as: :handle
    end
    member do
      get "destroy_invitation" => "users#destroy_invitation"
      get 'tasks_of_day' => "tasks#tasks_of_day"
    end
  end
  post "invite_user" => "organizations#invite_user", as: :invite_user
  get 'main_pages/start'
  get 'get_tasks' => "tasks#get_tasks", as: :get_tasks
  get 'create_task' => "tasks#create_task", as: :create_task

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
