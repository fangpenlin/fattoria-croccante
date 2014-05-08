class MailsController < ApplicationController
  # Transform the sent params into a
  # Cornerstore::Order object
  before_action :parse_params

  # We respond to HTML and text
  respond_to :html, :text

  # Use the mail layout
  layout 'mail'

  # Don't request authenticity token
  skip_before_action :verify_authenticity_token

private
  def order_params
    params.require(:order)
  end

  def parse_params
    @order = Cornerstore::Order.new(order_params)
  end

public

  def placed_notification
    respond_with @order
  end

  def shipped_notification
    respond_with @order
  end

  def paid_notification
    respond_with @order
  end

  def canceled_notification
    respond_with @order
  end
end
