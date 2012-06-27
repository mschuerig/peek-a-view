# PeekAView

Experimental software ahead! Use with caution, if at all.

## What?

This gem provides a Rails engine adds functionality to an application
to show any of its views with stubbed data.

## Why?

To get to a certain page in your application you may have to jump
through more hoops than is convenient. Or it might be complicated to
set up the necessary data. Or it may require external services to do
something interesting. Or you want to run a validator on all your
pages without being bothered by a login.

## How?

Declare a dependency on this gem in your Gemfile

    gem 'peek-a-view'

Mount the PeekAView engine in config/routes.rb

    if Rails.env.development? || Rails.env.test?
      mount PeekAView::Engine => '/peek-a-view'
    end

Write YAML files defining stub objects to use in your views and place
them in

    test/fixtures/view_stubs/<controller>/<template>.yml

for example

    test/fixtures/view_stubs/posts/index.yml

Start your application and point your browser at

    http://localhost:3000/peek-a-view/posts/index


## When (will it work properly)?

Not quite yet.

### What's broken?

* Make sure models from all paths (app, engines, ...) are loaded
  before reading stubs.
* Writing the YAML-stubs is a nuisance; I'm looking for a good way
  to include parsed content instead of textual inclusion.


This project rocks and uses MIT-LICENSE.
