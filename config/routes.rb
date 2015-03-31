Hackweek::Application.routes.draw do

  get 'markdown/preview'

  devise_for :users

  resources :users do
    collection do
      get 'me'
    end
    member do
      post 'keyword', to: "users#add_keyword"
      delete 'keyword', to: "users#delete_keyword", constraints: { keyword: /[^\/]+/ }
    end
  end

  # compat routes
  get 'archive/projects/:id', to: "projects#old_archived"

  scope '(:episode)' do
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
        post 'advance'
        post 'recess'
        post 'episode', to: "projects#add_episode"
        delete 'episode', to: "projects#delete_episode"
        post 'keyword', to: "projects#add_keyword"
        delete 'keyword', to: "projects#delete_keyword", constraints: { keyword: /[^\/]+/ }
      end
      resources :comments
    end
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

  get "howto", to: "application#howto"
  get "news", to: "announcements#index"
  get "about", to: "announcements#about"
  
  root 'projects#index'

end
