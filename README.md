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

Write view definitions in {spec|test}/peek_a_view.rb like this

    PeekAView.configure do |config|
      # Define stubbing methods or use the ones you already have for your tests.
      def stub_article
        ...
      end

      config.all_views do |v|
        v.current_user = User.new
      end

      config.view 'articles/index' do |v|
        v.articles = (1..10).map { |i| stub_article }
      end

      config.view 'articles/new', 'articles/edit' do |v|
        v.params  = { id: '1' } # needed for URL generation
        v.article = stub_article
      end
    end

Start your rails application and point your browser at

    http://localhost:3000/peek-a-view/

If everything went well, you see a list of links to your views.


This project rocks and uses MIT-LICENSE.
