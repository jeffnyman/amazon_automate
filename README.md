
# Amazon Automation Example

This is a very slimmed down example of a test script operating against the Amazon web interface, with a focus on using page objects as the method of navigation.

## Usage

I have `setup.sh` script if you want to attempt to get all the necessary elements set up on your machine.

If you already have a Ruby-based environment, you just need to do `bundle install` from the project directory.

In the project directory, just run `rspec amazon_script.rb`

## Exercise Parameters

Search Amazon.com for the following items:

*	Software Testing: Essential Skills for First Time Testers: Software Quality Assurance:From scratch to end
* Skullcandy Bluetooth Hesh 2.0 Black Wireless Bluetooth Headphones
* OLED55B6P TV

Add each item to your cart.
Go to the cart and confirm all three items are in the cart.
Remove the Skullcandy Bluetooth Hesh 2.0 Black Wireless Bluetooth Headphones.
Confirm the headphones are no longer in the cart.

Perform regular assertions on each of the pages to confirm general page basics.
Write the tests in the Page object model.

### Notes on Exercise Modifications

The challenge listed just searching for "OLED55B6P TV" but that can periodically lead to another item being found. You don't want to use data that can be vaguely applied. That's a test smell. I can see how from a challenge standpoint it might be interesting to see how someone deals with that; but from a realistic testing standpoint, you wouldn't do interesting code tricks in that case. You would simply refine your test data. This also allows you to streamline a data buider pattern, which you should be doing. What I say here also applies to the Bluetooth headphones.

Now, granted, you might have separate tests that validate whether ambiguous names show up correctly or whether an option shows up regarding "Showing most relevant results. See all results for {whatever}". But, if that's the case, that's how the test problem would need to be specified.

Also, one of the books is an ebook only. You can't add ebooks to the cart. A better exercise would include a book that has multiple formats. So that's what I did here. However, to keep things tractable, I only searched for the paperback. I could look for the "Kindle" or "Paperback" elements and click them but, again, given that this is an exercise, I'm opting to showcase the basics.

Also note that doing this on live data that you don't control can be tricky because the items can become out of stock. That was close to happening with one of the items in the proposed example. It may, in fact, happen by the time someone looks at this.

My data builder uses `product_data.yml` as such:

```yaml
default item set:
  item one: "Perfect Software: And Other Illusions about Testing Paperback"
  item two: "Skullcandy Hesh 2 Bluetooth Wireless Headphones with Mic, Black"
  item three: "OLED55B6P Flat 55-Inch"
```

I took some shortcuts here that I wouldn't necessarily take for a robust set of tests. I do that in the realization that this exercise is an abstraction. It's essentially showing if I _can_ do something and if I can _think_ about what I'm doing.

## Explanations

I kept the runner and the supporting mechanisms very simple here for purposes of focusing on what I did. Here I'll call out a few things as to how the page models are used. I should note that I'm using my own micro-framework for this, which is called [Tapestry](https://github.com/jeffnyman/tapestry). Tapestry wraps watir-webdriver which, in turn, wraps selenium-webdriver.

Here I'm showcasing the use of a page object pattern with two other patterns: a context factory and a data builder.

### Context Factory

You will see the tests look like this:

```ruby
on_view(Amazon).add_items_to_cart(amazon_search_data)
on(Amazon).check_cart_for(amazon_search_data)
on(Cart).remove_item(amazon_search_data['item two'])
```

Here `on_view` and `on` are context factories that take in a page class. Actions are called on those factories. Notice how this is meant to read somewhat like English. Take a look at the page class for [Amazon](https://github.com/jeffnyman/amazon_automate/blob/master/models/amazon.rb). Notice the `begin_with` method. This is called automatically by Tapestry. Notice the `page_ready` declaration. This can be called automatically to make sure that, in this case, a "Learn More" element is on the page. You can have multiple of these declarations.

The same general pattern is followed throughout the exercise.

### Data Builder

In the test script, notice that line `on(Contact).use data_for "jeff nyman"`. This is a data builder.

What it does is take the data condition provided ("jeff nyman") and looks if it has that information in its data repository, which it does: [product_data.yml](https://github.com/jeffnyman/amazon_automate/blob/master/data/product_data.yml).

This is using my [DataBuilder](https://github.com/jeffnyman/data_builder) project, which can hook into a micro-framework. The data builder is actually a lot more sophisticated than I was able to show here with this kind of example.

### Waiting and Wait States

I have a sleep statement in `product.rb` (the page definition) that I'm not thrilled with. I did this because I have not yet figured out the best sensitivity to some aspects of how Amazon's site rejects the Mutation Observer. You can see I do checks for the DOM, like with this bit of code:

```ruby
if popover.present?
  popover.wait_until do |a|
    a.dom_updated?
  end

  no_coverage.click
end
```

Likewise in `amazon.rb` I do this:

```ruby
def search_for_item(item)
  search_text.wait_until(&:dom_updated?).set item
  search.click
end
```

These are library-agnostic calls to check if the DOM has been updated in any way.

### Performance (DOM and Otherwise)

You will notice a commented out line in my script: `# analyze_from(Tapestry.browser.performance)`. That uses my [Test Performance](https://github.com/jeffnyman/test_performance) gem to get information about how the script itself is performing in a way that is compliant with the W3C Navigation standard that is also being utilized by WebDriver.

### Where Do Assertions / Expectations Go?

There is a lot of debate about whether test scripts should hold assertions/expectations or whether those should be delegated to action methods in the page classes. Here you'll see I have mostly adopted the latter but I also do the former when it makes sense. The reason I focused on the latter here is because I wanted to showcase the page object pattern with the other patterns. And, as we know, pattern choice can often help us decided other logistics.

For example, consider how in the `amazon_script` I do have assertions checking aspects of the test execution. But in `amazon.rb` I have expectations in the page definitions themselves.

### Wait! Aren't page objects out of date?

No. But I have also practiced a lot with the screenplay pattern. Which was originally the journey pattern, which actually predates the page object pattern. I didn't want to confuse the issue here, but I have written [some screenplay posts](http://testerstories.com/?s=screenplay) if you want to see my thoughts on that.

### Wait! Aren't we just supposed to use workflows now?

Those can be effective. As with the screenplay, I didn't want to defocus this exercise but I have written an extension called [test_workflow](https://github.com/jeffnyman/test_workflow) that does this as well. In fact, it uses Amazon as an example. From the readme page on that, I'm sure you can see how I would apply that to this exercise.

## Other Examples / Similar Work

I have a similar set of examples you can check out that I have provided as part of a similar project for teaching these concepts. That project, called [lucid_ruby](https://github.com/jeffnyman/lucid_ruby) uses Cucumber as the runner. Of note:

* [page classes](https://github.com/jeffnyman/lucid_ruby/tree/master/models)
* [steps](https://github.com/jeffnyman/lucid_ruby/tree/master/steps)

This repository is a much more elaborate implementation and I would be happy to go over specific details about it.

I have also done something similar in Java, in my [lucid-jvm](https://github.com/jeffnyman/lucid-jvm) project. Of note:

* [page classes](https://github.com/jeffnyman/lucid-jvm/tree/master/src/test/java/com/testerstories/testing/pages)
* [checks](https://github.com/jeffnyman/lucid-jvm/tree/master/src/test/java/com/testerstories/testing/checks)

This repository is less elaborate than the Ruby simply because Java doesn't allow you quite the same freedom of expression that you can get with Ruby.
