Things to do.

* [ ] Add documentation for all this all works
* [ ] Use Sinatra or Rack Middleware instead of Rails for webhook endpoint

Classes to write:

* [ ] Notifier (publishes webhooks)
* [ ] WebhooksController
* [ ] Dispatcher (routes event names to a proc/class)
* [ ] Subscriber (responds to `api_key`, `url`, etc.)
* [ ] Worker (default Sidekiq worker)
