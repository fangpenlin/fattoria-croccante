class LineItemsController < ApplicationController

public
  def create
    # Sanitize the parameters
    li_params = params.require(:cornerstore_line_item).permit(:qty, :product_id, :variant_id)

    # Get the product and the variant which
    # should be added
    @product = Cornerstore::Product.find(li_params[:product_id])
    @variant = @product.variants.find(li_params[:variant_id])

    # Check if the cart is already known at Cornerstore. If not we now
    # create a new cart here
    if @cart.new?
      # During cart creation we set the callbacks that Cornerstore uses
      # for checkout and later email and document generation
      @cart = Cornerstore::Cart.create({
        # Success redirect URL as well as cart URL *must* be set, otherwise
        # the cart creation will fail. Cornerstore uses these URLs to redirect
        # the user in case the checkout is aborted or completed.
        success_redirect_url:           "http://fattoria-croccante.herokuapp.com/cart/success",
        cart_url:                       "http://fattoria-croccante.herokuapp.com/cart",

        # These callbacks are optional. Whenever Cornerstore needs to generate document
        # it will call this URL and provide your code with a JSON representation of the Order.
        # Your code must respond with a binary PDF data stream which is then displayed to your
        # customer in the Cornerstore Manager. If you do not supply these URLs the buttons for
        # invoice and delivery note will not be shown in the manager, effectively disabling these
        # functions. Please refer to our documentation for more information about this.
        # Use HTTPS for these callbacks!
        invoice_pdf_callback_url:       "https://fattoria-croccante.herokuapp.com/documents/invoice",
        delivery_note_pdf_callback_url: "https://fattoria-croccante.herokuapp.com/documents/delivery_note",

        # These callbacks are optional. Whenever Cornerstore needs to send a message
        # to the user because the order has completed a certain step (placed, shipped, paid, etc...)
        # it will call these URLs with the orders JSON. Our code then needs to respond to these
        # calls with the contents of the respective email. If you do not supply these URLs here,
        # no emails will be sent. See documentation for more info about this, including how to
        # test email callbacks. Use HTTPS for these callbacks!
        placed_email_callback_url:      "http://fattoria-croccante.herokuapp.com/mails/placed_notification",
        shipped_email_callback_url:     "http://fattoria-croccante.herokuapp.com/mails/shipped_notification",
        paid_email_callback_url:        "http://fattoria-croccante.herokuapp.com/mails/paid_notification",
        canceled_email_callback_url:    "http://fattoria-croccante.herokuapp.com/mails/canceled_notification"
      })

      # Connect the current user with his cart
      session[:cart_id] = @cart.id
    end

    # Finally we create the line item right from the variant.
    # Cornerstore handles it all, even if the variant is already
    # in the cart it will silently adjust the qty
    @line_item = @cart.line_items.create_from_variant(@variant, qty: li_params[:qty] || 1)

    # And we save it. If there were errors we use the Rails
    # flash system to notifiy the user
    if @line_item.valid?
      flash[:notice] = 'The product was successfully added to your cart'
    else
      flash[:errors] = @line_item.errors.full_messages
    end

    # And let's got back to the product
    redirect_to :back
  end

  def update
    # Try to find the line item
    @line_item = @cart.line_items.find(params[:id])

    # Get the params
    # Qty is the only thing that can be updated
    li_params = params.require(:cornerstore_line_item).permit(:qty)

    # Set the new qty or set it to 1 if it wasn't
    # supplied as parameter
    @line_item.qty = li_params[:qty] || 1

    # If the qty was set to 0 will remove the line item
    # otherwise we just save it, check for errors and then
    # go back
    if @line_item.qty == 0
      @line_item.destroy
    else
      # And we save it. If there were errors we use the Rails
      # flash system to notifiy the user
      if @line_item.save
        flash[:notice] = 'Your line item was successfully updated'
      else
        flash[:errors] = @line_item.errors.full_messages
      end
    end

    # And let's go back to the cart
    redirect_to cart_url
  end

  def destroy
    @line_item = @cart.line_items.find(params[:id])
    @line_item.destroy
    redirect_to cart_url, notice: 'The product was successfully removed from your cart'
  end
end
