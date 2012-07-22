namespace 'peek-a-view' do

  task :prepare => :environment do
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

  desc "List views served by Peek-a-View"
  task :list => :prepare do
    require 'peek_a_view/tools'

    puts "Views served by Peek-a-View"
    @view_uris.each do |uri|
      puts PeekAView::Tools.view_from_uri(uri, prefix: @index_uri)
    end
  end


  desc "Run all checks"
  task :check => [:validate, :yslow]


  desc "Check view markup with validator.nu"
  task :validate => :prepare do
    require 'peek_a_view/tools/html_validator'

    validator_uri = ENV['HTML_VALIDATOR'] || 'http://localhost:8888/'
    validator     = PeekAView::Tools::HtmlValidator.new(
      validator_uri: validator_uri,
      prefix:        @index_uri
    )
    validator.clean_reports

    @view_uris.each do |uri|
      validator.report(uri)
    end
  end


  desc "Check views with YSlow"
  task :yslow => :prepare do
    require 'peek_a_view/tools/yslow'

    yslow = PeekAView::Tools::YSlow.new(prefix: @index_uri)
    yslow.clean_reports

    @view_uris.each do |uri|
      yslow.report(uri)
    end
  end
end
