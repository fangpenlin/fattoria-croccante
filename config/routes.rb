Rails.application.routes.draw do

  # In our example store every product is within
  # a collection, so we build the routes accordingly.
  # However such a configuration is not mandatory, products
  # could also be fetched directly

  # Since we want collection to appear directly at the root
  # level we add a path config option to do just that
  resources :collections, only: [:index, :show], path: '/' do
    # Within a collection the product should also
    # be available directly without a products part
    # in the URI
    resources :products, only: [:show], path: '/'
  end


end
