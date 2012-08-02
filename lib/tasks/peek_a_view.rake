namespace 'peek-a-view' do

  task :prepare do
    ENV['PEEK_A_VIEW'] = 'true'

    # Up to here, Rails is running in the development environment, but we
    # want the test environment. Getting there takes some coaxing.
    Rails.env          = (ENV['RAILS_ENV'] ||= 'test')
    # reset cached paths
    Rails.application.config.instance_variable_set(:@paths, nil)
    # load the environment again
    require Rails.root + "config/environment"

    Rake::Task['peek-a-view:run_server'].invoke
  end

  task :run_server do
    require 'open-uri'
    require 'capybara/rails'
    require 'capybara/server'

    @view_server = Capybara::Server.new(Capybara.app)
    @view_server.boot

    @index_uri = @view_server.url('/peek-a-view')
    open(@index_uri, 'Accept' => 'application/json') do |resp|
      @view_uris = ActiveSupport::JSON.decode(resp)
    end
  end

  task :init_html_validator do
    require 'peek_a_view/tools/html_validator'

    validator_uri = ENV['HTML_VALIDATOR'] || 'http://localhost:8888/'
    @html_validator     = PeekAView::Tools::HtmlValidator.new(
      validator_uri: validator_uri,
      prefix:        @index_uri,
      encoding:      Rails.configuration.encoding
    )
  end

  desc "List views served by Peek-a-View"
  task :list => :prepare do
    require 'peek_a_view/tools'

    puts "Views served by Peek-a-View"
    @view_uris.each do |uri|
      puts PeekAView::Tools.view_from_uri(uri, prefix: @index_uri)
    end
  end

  desc "Run all checks"
  task :check => 'check:run'

  namespace :check do
    task :run => [:html, :speed]

    task :prepare do
      Rake::Task['peek-a-view:prepare'].invoke
    end

    desc "Check view markup with validator.nu"
    task :html => [:prepare, :init_html_validator] do
      @view_uris.each do |uri|
        puts "-" * 70
        puts "Validation results for #{uri}"
        @html_validator.check(uri)
      end
    end

    desc "Check views with YSlow and generate reports"
    task :speed => :prepare do
      require 'peek_a_view/tools/yslow'

      yslow = PeekAView::Tools::YSlow.new(prefix: @index_uri)

      @view_uris.each do |uri|
        yslow.check(uri)
      end
    end
  end


  desc "Run all checks and generate reports"
  task :report => 'report:run'

  namespace :report do
    task :run => [:html, :speed]

    task :prepare do
      Rake::Task['peek-a-view:prepare'].invoke
    end

    desc "Check view markup with validator.nu and generate reports"
    task :html => [:prepare, :init_html_validator] do
      @html_validator.clean_reports

      @view_uris.each do |uri|
        @html_validator.report(uri)
      end
    end

    desc "Check views with YSlow and generate reports"
    task :speed => :prepare do
      require 'peek_a_view/tools/yslow'

      yslow = PeekAView::Tools::YSlow.new(prefix: @index_uri)
      yslow.clean_reports

      @view_uris.each do |uri|
        yslow.report(uri)
      end
    end
  end
end
