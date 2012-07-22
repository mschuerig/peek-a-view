require 'active_support/ordered_options'
require 'peek_a_view/view'

module PeekAView
  class Configuration < ActiveSupport::OrderedOptions
    def initialize(*)
      super
      clear_views!
    end

    def views_file
      Array(views_path).map { |p| File.join(Rails.root, p) }.find { |p| File.file?(p) }
    end

    def load_views
      clear_views!
      if (file = views_file)
        load file
      else
        raise "No peek-a-view definitions found." # TODO proper exception class
      end
    end

    def clear_views!
      @views  = { }
      @common = []
    end

    def view(*names, &block) # :yields: a view object
      raise ArgumentError, "A view must have a least one name." unless names.length > 0
      names.each do |name|
        (@views[name] ||= PeekAView::View.new(name, @common)).tap do |view|
          view.record(block)
        end
      end
    end

    def all_views(&block) # :yields: a common view object
      @common.tap do |common|
        @common << block
      end
    end

    def views
      @views
    end
  end
end
