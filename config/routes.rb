Rails.application.routes.draw do
  concern :oai_provider, BlacklightOaiProvider::Routes.new


  mount Blacklight::Oembed::Engine, at: 'oembed'
  mount Riiif::Engine => '/images', as: 'riiif'
  mount Spotlight::Engine, at: '/exhibits'
  concern :range_searchable, BlacklightRangeLimit::Routes::RangeSearchable.new
  mount Blacklight::Engine => '/'
  mount BlacklightAdvancedSearch::Engine => '/'


  get "nearbys/:coordinates/(:distance)" => "nearbys#show"
  root to: "catalog#index" # replaced by spotlight root path

  get 'thumbnail_link/:id' => 'thumbnail_links#show'

  get ":page" => "pages#show", constraints: lambda { |request|
    %w(catalog sidekiq indexing).exclude?(request.params[:page])
  }

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  concern :searchable, Blacklight::Routes::Searchable.new

  resource :catalog, only: [:index], as: 'catalog', path: '/catalog', controller: 'catalog' do
    concerns :oai_provider

    concerns :searchable
    concerns :range_searchable
  end

  resource :advanced, only: [:index], as: 'advanced', path: '/advanced', controller: 'advanced' do
    concerns :searchable
    concerns :range_searchable
  end

  concern :exportable, Blacklight::Routes::Exportable.new

  resources :solr_documents, only: [:show], path: '/catalog', controller: 'catalog' do
    concerns :exportable
  end

  resources :bookmarks do
    concerns :exportable

    collection do
      delete 'clear'
    end
  end

  namespace :spotlight do
    resources :exhibit do
      ###
      # Wires up to our app/overrides/spotlight/filters_controller_override.rb
      # extension
      resources :filters, only: [:destroy]
    end
  end

  resources :iiif, only: [] do
    member do
      get :manifest
      get :search
      get :autocomplete
    end
  end

  get 'contentdm-images' => 'contentdm_images#show'
  get 'contentdm-images/info' => 'contentdm_images#info'
  get 'thumbnails/:id/(:type)' => 'thumbnails#show', as: 'thumbnail'

  get 'indexing' => 'indexing#index', as: 'indexing'
  post 'indexing' => 'indexing#create'

  devise_for :users, skip: [:logout]
  devise_scope :user do
    get 'users/sign_out', to: 'devise/sessions#destroy'
  end

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
