ActionController::Routing::Routes.draw do |map|
  map.resource :session, :controller => :main, :only => %w(create destroy), :member => { :forgot => :post }
  map.dashboard '/dashboard', :controller => 'main', :action => 'dashboard', :conditions => { :method => :get }
  map.dashboard_blog'/dashboard/:name', :controller => 'main', :action => 'dashboard_for_blog', :conditions => { :method => :get }

  map.resources :users, :except => %w(index) do |user|
    user.resources :tags, :only => %w(show index)
  end
  map.resources :tags, :only => %w(show index)

  map.resources :posts, :except => %w(index)
  map.connect 'posts/new/:id', :controller => 'posts', :action => 'repost', :conditions => { :method => :get }, :requirements => { :id => /[0-9]+/ }
  map.compose 'posts/new/:type', :controller => 'posts', :action => 'new', :conditions => { :method => :get }

  #map.resources :blogs, :requirements => { :id => /[a-zA-Z]+[0-9a-zA-Z]{4,}(-[0-9a-zA-Z]+)*/ } do |blog|
  map.resources :blogs, :requirements => { :id => /[-\w]+/ } do |blog|
    blog.resource :following, :controller => :following, :only => %w(create destroy)
  end
  #map.invite 'blogs/:id/invite', :controller => 'blogs', :action => 'invite', :conditions => { :method => :post }, :requirements => { :id => /[a-zA-Z]+[0-9a-zA-Z]{4,}(-[0-9a-zA-Z]+)*/ }
  map.invite 'blogs/:id/invite', :controller => 'blogs', :action => 'invite', :conditions => { :method => :post }, :requirements => { :id => /[-\w]+/ }

  map.resources :nodes, :except => %w(new edit) do |node|
    node.resources :mappings, :controller => 'node_mappings', :except => %w(new edit)
    node.resources :permissions, :controller => 'node_permissions', :except => %w(new edit)
  end


  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller

  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  map.connect "/login", :controller => "main", :action => "index"
  map.wildcard "*path", :controller => "site", :action => "show", :conditions => { :method => :get }
  map.root :controller => "main"


  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing or commenting them out if you're using named routes and resources.
  # map.connect ':controller/:action/:id'
  # map.connect ':controller/:action/:id.:format'
end
