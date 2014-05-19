class DocumentsController < ApplicationController
  # Transform the sent params into a
  # Cornerstore::Order object
  before_action :parse_params

  # We respond to PDF
  respond_to :pdf

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
  def invoice
    respond_with @order
  end

  def delivery_note
    respond_with @order
  end
end
