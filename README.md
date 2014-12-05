# Bnr::Webhooks

Provides a collection of tools for sending and receiving webhooks. This
includes:

* Controller for receiving incoming webhooks from other BNR services
* Methods for sending webhooks to subscribers
* Methods for signing and validating signatures in webhooks to confirm they
come from a trusted party

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'bnr-webhooks'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install bnr-webhooks

## Usage

### Initialization

Add the following code to an initializer in your Rails application (perhaps
in `config/initializers/bnr-webhooks.rb`):

```ruby
Bnr::Webhooks.configure do |config|
  config.api_key = 'your_api_key'
end
```

### Add a webhook endpoint

You can set up a Rails controller to handle incoming webhooks:

```ruby
class WebhookController < ApplicationController
  include Bnr::Webhooks::Controller
end
```

You may want to disable various security measures in this controller, such as authenticity tokens. The `Receiver` will handle verification.

After you set up a route, the controller will listen for a `POST` (create) and process the contents with an empty dispatcher. This isn't incredibly useful, so you will want to override defaults to use your own dispatcher:

```ruby
class WebhookController < ApplicationController
  include Bnr::Webhooks::Controller

  private

  def dispatcher
    Bnr::Webhooks::Dispatcher.new(
      "widgets.destroy" => WidgetRemovalEvent
    )
  end
end
```

If you are just using a hash for dispatching, you can instead override the `mapping` method:

```ruby
class WebhookController < ApplicationController
  include Bnr::Webhooks::Controller

  private

  def mapping
    { "widgets.destroy" => WidgetRemovalEvent }
  end
end
```

### Handle webhooks in the background

By default, the webhook controller will use an inline worker. However, it's easy to inject your own (proper) worker so long as it responds to the `call` method (similar to Procs):

```ruby
class WebhookWorker < Bnr::Webhooks::Worker
  include Sidekiq::Worker

  def self.call(handler, event, source)
    perform_async(handler.to_s, event, source)
  end

  def perform(handler_name, event, source)
    handler = handler_name.constantize
    super(handler, event, source)
  end
end
```

Don't forget to specify this worker in your webhook controller:

```ruby
class WebhookController < ApplicationController
  include Bnr::Webhooks::Controller

  private

  def worker
    WebhookWorker
  end
end
```

### Bring your own subscribers

When sending a webhook you will need to provide a subscriber. Subscribers need to
respond to two methods:

* `api_key` - this is a shared secret between the system sending the webhook and
the subscriber
* `url` - the url the system the subscriber wants webhook requests sent to

## Contributing

1. Fork it ( https://github.com/[my-github-username]/bnr-webhooks/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
