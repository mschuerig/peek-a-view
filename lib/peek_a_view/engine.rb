require 'peek_a_view/configuration'

module PeekAView
  class Engine < ::Rails::Engine
    config.peek_a_view = PeekAView::Configuration.new
  end
end
