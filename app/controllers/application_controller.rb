class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # Get all collections from the merchant for
  # the navigation and set the cart
  before_action :set_collections, :set_cart


private
  # Set the collections for navigation
  def set_collections
    @collections = Cornerstore::Collection.all
  end

  # Check if the user already has a cart assigend by asking the session
  # if it holds a cart_id key. If so we try to fetch this cart from Cornerstore
  # If there is no cart a dummy cart will be created. A persisted cart object
  # will only be created if there is no cart when the user adds the first line
  # item. This is done by the cart controller and enhances performance.
  def set_cart
    @cart = session.has_key?(:cart_id) ? Cornerstore::Cart.find(session[:cart_id]) : Cornerstore::Cart.new

  # We rescue any not found errors here, because the cart could have been deleted in the Cornerstore
  # while the session here still holds its ID. If that happend we just create a new empty cart
  rescue
    @cart = Cornerstore::Cart.new
  end
end
