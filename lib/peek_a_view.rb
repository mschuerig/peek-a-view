require 'peek_a_view/engine'
require 'peek_a_view/configuration'

module PeekAView
  STUBS_FILE = 'peek_a_view.rb'

  class << self

    def configure # :yields: config
      yield config
    end

    def load_stubs
      config.load_stubs
    end

    private

    def config
      PeekAView::Engine.config.peek_a_view
    end
  end
end

PeekAView.configure do |c|
  c.stubs_path = [
    File.join('spec', PeekAView::STUBS_FILE),
    File.join('test', PeekAView::STUBS_FILE)
  ]
end
