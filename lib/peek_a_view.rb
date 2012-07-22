require 'peek_a_view/engine'
require 'peek_a_view/configuration'

module PeekAView
  VIEWS_FILE = 'peek_a_view.rb'

  class << self

    def configure # :yields: config
      yield config
    end

    def load_views
      config.load_views
    end

    private

    def config
      PeekAView::Engine.config.peek_a_view
    end
  end
end

PeekAView.configure do |config|
  config.views_path = [
    File.join('spec', PeekAView::VIEWS_FILE),
    File.join('test', PeekAView::VIEWS_FILE)
  ]
end
