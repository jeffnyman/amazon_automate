#!/usr/bin/env ruby

require_relative './framework'

RSpec.configure do |config|
  config.formatter = "documentation"
  config.before(:example)  { Tapestry.set_browser :firefox }
  config.after(:example)   { Tapestry.quit_browser }
  include Test::Unit::Assertions
end

RSpec.describe "Amazon" do
  context "shopping experience" do
    it "allows adding products to the shopping cart" do
      amazon_search_data = using_data_from "default item set"

      on_view(Amazon).add_items_to_cart(amazon_search_data)

      on(Amazon).check_cart_for(amazon_search_data)

      on(Cart).remove_item(amazon_search_data['item two'])

      on(Cart) do |page|
        result = page.check_purchase_list_for(amazon_search_data['item one'])
        assert result == true

        result = page.check_purchase_list_for(amazon_search_data['item three'])
        assert result == true

        result = page.check_purchase_list_for(amazon_search_data['item two'])
        assert result == false
      end
    end
  end
end

# analyze_from(Tapestry.browser.performance)
