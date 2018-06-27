Hackweek::Application.routes.draw do

  get 'markdown/preview'

  devise_for :users

  resources :users, only: [:index, :show]  do
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
        get 'autocomplete_project_title'
        get 'archived'
        get 'finished'
        get 'newest', to: 'projects#index'
        get 'popular'
        get 'biggest'
        get 'random'
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
      resource :project_follows, only: [] do
        member do
          post '/create', to: 'projects/project_follows#create'
          delete '/destroy', to: 'projects/project_follows#destroy'
        end
      end
      resources :comments
    end
  end

  get '/reply/:id', to: "comments#reply_modal", as: 'reply_modal'

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

  get "about", to: "about#show"
  get "howto", to: "about#show"

  get "news", to: "announcements#index"
  get "users/:id/edit", to: "users#edit", as: "user_edit"
  patch 'users/:id', to: 'users#update'

  root 'about#index'

end
