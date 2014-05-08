Rails.application.routes.draw do

  # The users cart will be available
  # as /cart for each user
  resource :cart, only: [:show] do
    resources :line_items, only: [:create, :update, :destroy]
  end

  # Product search
  resource :search, only: [:show]
  resources :products, only: [:show] # products without a collection

  # Callbacks for email content
  resources :mails do
    collection do
      post :placed_notification
      post :paid_notification
      post :shipped_notification
      post :canceled_notification
    end
  end

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
