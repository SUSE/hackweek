Rails.application.routes.draw do

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
        get "search", to: "search#result"
      end
      member do
        get 'like'
        get 'dislike'
        match 'join', via: :post, defaults: { format: 'js' }
        match 'leave', via: :post, defaults: { format: 'js' }
        post 'advance'
        post 'recess'
        post 'episode', to: "projects#add_episode", defaults: { format: 'js' }
        delete 'episode', to: "projects#delete_episode", defaults: { format: 'js' }
        post 'keyword', to: "projects#add_keyword"
        delete 'keyword', to: "projects#delete_keyword", constraints: { keyword: /[^\/]+/ }
      end
      resources :followers, only: [] do
        collection do
          get '/', to: 'projects/project_follows#index'
          post '/', to: 'projects/project_follows#create'
          delete '/', to: 'projects/project_follows#destroy'
        end
      end
      resources :comments
    end
  end

  get '/reply/:id', to: "comments#reply_modal", as: 'reply_modal'

  resources :comments, only: [:new, :create] do
    resources :comments, only: [:new, :create]
  end

  resources :announcements do
    member do
      get "enroll"
    end
  end

  resources :notifications do
    collection do
      post :mark_as_read
    end
  end

  resources :episodes do
    member do
      get "activate"
    end
  end

  resources :faqs, except: [:show]
  get '/faq', to: redirect('/faqs')

  get "keyword/tokens"
  get "gallery", to: "gallery#index"

  get "about", to: "about#show"
  get "howto", to: "about#show"

  get "news", to: "announcements#index"
  get "users/:id/edit", to: "users#edit", as: "user_edit"
  patch 'users/:id', to: 'users#update'

  root 'about#index'

end
