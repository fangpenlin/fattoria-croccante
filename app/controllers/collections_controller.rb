class CollectionsController < ApplicationController

  # We don't display any kind of index page but since this controller is evoked
  # upon calling the root route we handle home here. We immeditaly redirect to the
  # first collection though
  def index
    redirect_to collection_url(@collections.first)
  end

  # Shows the collection referenced by ID. ID can be the actual
  # super ugly internal Cornerstore collection ID or a human-readable
  # slug. We recommand you use the latter (which will be automatically done
  # for you if you use Rails' link helpers or the to_param method
  def show
    # Get the collection itself
    @collection = Cornerstore::Collection.find(params[:id])

    # Get the products as well
    @products = @collection.products.to_a

    # Rails will then render the template views/collections/index
    # If the collection is not found a error will be raised that is
    # handled in the applications controller
  end
end
