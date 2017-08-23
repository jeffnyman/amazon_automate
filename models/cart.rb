class Cart
  include Tapestry

  spans   :product_titles,  class: 'sc-product-title'
  inputs  :delete,          value: 'Delete'

  def check_purchase_list_for(items)
    if items.class == String
      item_list = Hash.new
      item_list["item one"] = items
    else
      item_list = items
    end

    found_item = nil

    item_list.each do |item|
      found_item = false
      item_name = item[1]

      product_titles.each do |title|
        if title.text.include?(item_name)
          found_item = true
        end
      end
    end

    found_item
  end

  def remove_item(item)
    delete.each do |product|
      item_label = product.attribute_value('aria-label')
      if item_label.include? item
        product.click
      end
    end
  end
end
