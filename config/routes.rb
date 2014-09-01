Hackweek::Application.routes.draw do

  devise_for :users

  resources :users do
    collection do
      get 'me'
    end
    member do
      post 'keyword', to: "users#add_keyword"
      delete ':keyword', to: "users#delete_keyword", as: "keyword_delete", constraints: { keyword: /[^\/]+/ }
    end
  end

  resources :projects do
    collection do
      get 'archived'
      get 'finished'
      get 'newest'
      get 'popular'
      get 'biggest'
    end
    member do
      get 'like'
      get 'dislike'
      match 'join', via: :post
      match 'leave', via: :post
      match 'advance', via: :post
      match 'recess', via: :post
      post 'keyword', to: "projects#add_keyword"
      delete ':keyword', to: "projects#delete_keyword", as: "keyword_delete", constraints: { keyword: /[^\/]+/ }
    end
    resources :comments
  end
  
  resources :comments do
    resources :comments
  end

  resources :announcements do
    member do
      get "enroll" 
    end
  end

  resources :episodes do
    member do
      get "activate"
    end
  end

  get "keyword/tokens"
  post "api/import", to: "api#import" 
  get "gallery", to: "gallery#index"
  get "search", to: "search#result", as: "search"

  get "front/index"
  get "index.html", to: "front#index"
  get "front/awards"
  get "awards.html", to: "front#awards"
  get "front/howto"
  get "howto.html", to: "front#howto"
  get "front/news"
  get "news.html", to: "front#news"
  
  get 'user_root' => 'users#me'
  root 'front#index'

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
