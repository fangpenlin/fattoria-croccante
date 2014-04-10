class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # Get all collections from the merchant for
  # the navigation
  before_action :set_collections


private
  def set_collections
    @collections = Cornerstore::Collection.all
  end
end
