class Product
  include Tapestry

  input :add_to_cart_button,  title:  "Add to Shopping Cart"

  button :no_coverage,        text:   "No Thanks"
  div    :popover,            class:  "a-popover"

  page_ready { [add_to_cart.exists?, "Add to cart ability is not present"] }

  def add_to_cart
    add_to_cart_button.click

    # NOTE: I don't like having this in here. Right now this was put in
    # place to determine a sensitivity related to timing and the display
    # of a "sometimes popover" given that the mutation observer didn't
    # always work with the Amazon site.
    sleep 1

    if popover.present?
      popover.wait_until do |a|
        a.dom_updated?
      end

      no_coverage.click
    end
  end
end
