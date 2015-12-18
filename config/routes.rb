Rails.application.routes.draw do
  use_doorkeeper

  scope "/snl" do
    scope "/rest/v1" do
      resources :board, module: "rest/v1", :only=>[:new, :show, :update, :destroy, :index]
      resources :player, module: "rest/v1", :only=>[:create, :show, :update, :destroy]
      resources :move, module: "rest/v1", :only=>[:show]
    end
    scope "/rest/v2" do
      resources :board, module: "rest/v2", :only=>[:new, :show, :update, :destroy, :index]
      resources :player, module: "rest/v2", :only=>[:create, :show, :update, :destroy]
      resources :move, module: "rest/v2", :only=>[:show]
    end
    scope "/rest/v3" do
      resources :board, module: "rest/v3", :only=>[:new, :show, :update, :destroy, :index]
      resources :player, module: "rest/v3", :only=>[:create, :show, :update, :destroy]
      resources :move, module: "rest/v3", :only=>[:show]
    end
    scope "/soap/v1" do
      resources :wsdl, module: "soap/v1", :only=>[:create]
    end
    wash_out "soap/v1"
    wash_out "soap/v2"
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