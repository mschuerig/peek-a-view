# PeekAView

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


## Checking & Reporting

Peek-a-View includes a few Rake tasks and their support code for
checking the stubbed views with. Currently supported are

* the HTML5 validator from http://validator.nu/
* YSlow

The checkers are available through these tasks

    rake peek-a-view:check         # Run all checks
    rake peek-a-view:check:html    # Check view markup with validator.nu
    rake peek-a-view:check:speed   # Check views with YSlow and generate reports
    rake peek-a-view:report        # Run all checks and generate reports
    rake peek-a-view:report:html   # Check view markup with validator.nu and generate reports
    rake peek-a-view:report:speed  # Check views with YSlow and generate reports

Checks write their output to the console, reports generate xUnit-style (aka surefire)
reports in reports/html_validator and reports/yslow respectively.

These tasks have dependencies that are not explicitly declared for this gems.
This is to avoid dragging in gems for task that you may not want to use.

### Requirements for HTML5 checking/reporting

HTML5 checks require at instance of Validator.nu to be available at
http://localhost:8888/ or whatever URI the environment variable HTML_VALIDATOR
contains.

You can obtain the sources for the validator from
http://about.validator.nu/#src


### YSlow

YSlow runs as a JavaScript in the headless browser PhantomJS.
A version of the YSlow script itself is packaged with this gem.
To use it, you need to install PhantomJS

http://code.google.com/p/phantomjs/



This project rocks and uses MIT-LICENSE.
