class ProductsController < ApplicationController

  def show
    @collection = Cornerstore::Collection.find(params[:collection_id]) if params.has_key?(:collection_id)
    @product    = Cornerstore::Product.find(params[:id])
  end

end
