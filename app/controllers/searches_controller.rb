class SearchesController < ApplicationController

private
  def search_params
    params.require(:cornerstore_search).permit(:keywords)
  end

public
  def show
    @search = Cornerstore::Search.new(search_params[:keywords])
    @search.run
    @products = @search.results
  end
end
