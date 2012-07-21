module PeekAView
  class View < ActiveSupport::OrderedOptions
    def initialize(name, common_block = nil)
      @name       = name
      self.params = nil # just to initialize params
      @blocks = []
      record(common_block) if common_block
    end

    def record(block)
      @blocks << block
    end

    def template
      super || @name
    end

    def layout
      'application' # TODO be smarter
    end

    def params=(new_params)
      *controller, action = template.split('/')
      augmented = (new_params || { }).reverse_merge(
        controller: controller.join('/'),
        action:     action
      )
      super(augmented)
      augmented
    end

    def fixture(name)
      fixture_dir = Rails.root + 'spec/fixtures/peek_a_view' # TODO config
      file = File.join(fixture_dir, name)
      File.read(file)
    end

    def variables(options = {})
      @blocks.flatten.each { |block| block.call(self, options) }
      self
    end
  end
end
