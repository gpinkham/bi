Rails.application.routes.draw do

 root :to => 'home#index'

  resources :questions do
    member do
      get 'result'
      get 'download_result'
      post 'add_tag'
    end

    collection do
      get 'search'
    end
  end

  get 'questions/tags/:tag' => 'questions#tags', :as => 'question_tag'
  get 'kpis/tags/:tag' => 'kpis#tags', :as => 'kpi_tag'

  resources :kpis do
    member do
      post 'add_categorization'
      post 'add_tag'
    end
    collection do
      get 'stats'
      get 'search'
    end
  end

  resources :reports do
    collection do
    end
  end

  resources :visualizations, :only => :index
  get '/visualizations/:action', :controller => 'visualizations'
  get '/kpi_menu' => 'kpis#kpi_menu', :as => 'kpi_menu'



end
