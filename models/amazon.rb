class Amazon
  include Tapestry
  include Tapestry::Factory

  url_is      "https://www.amazon.com/"
  url_matches /(smile.|www.)?amazon.com/
  title_is    "Amazon.com Online Shopping for Electronics, Apparel, Computers, Books, DVDs & more"

  element :logo,        class:  'nav-logo-base nav-sprite'
  element :search_text, id:     'twotabsearchtextbox'
  input   :search,      value:  'Go'

  link    :cart,        id:     'nav-cart'
  span    :cart_count,  id:     'nav-cart-count'

  ul      :item_list,   id:     's-results-list-atf'

  page_ready { [logo.exists?, "Amazon logo is not present"] }

  def begin_with
    move_to(0, 0)
    resize_to(screen_width, screen_height)
  end

  def add_items_to_cart(items)
    items.each do |item|
      item_name = item[1]
      search_for_item(item_name)

      item_to_buy = find_item_in_list(item_name)
      expect(item_to_buy).to_not be_nil

      item_to_buy.click

      on_new(Product).add_to_cart
    end
  end

  def search_for_item(item)
    search_text.wait_until(&:dom_updated?).set item
    search.click
  end

  def find_item_in_list(item)
    item_to_buy = nil

    item_list.lis.find do |list_item|
      list_item.h2s.find do |item_heading|
        item_to_buy = item_heading if item_heading.text.include? item
      end
    end

    item_to_buy
  end

  def check_cart_for(items)
    cart.click
    result = on(Cart).check_purchase_list_for(items)
    expect(result).to be_truthy
  end
end
