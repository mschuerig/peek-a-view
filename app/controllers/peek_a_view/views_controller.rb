require 'peek_a_view/stub_loader'

module PeekAView
  class ViewsController < ::ApplicationController # ActionController::Base

    def show
      template = find_template
      stub_instance_variables_for!(template, variant: params[:variant])

      flash[:alert]  = params[:flash_alert]
      flash[:notice] = params[:flash_notice]

      render template: template, layout: find_layout(template)
    end

    private

    def _prefixes
      # Fake the path prefix for partials specified only with a relative path.
      # As we are not rendering them with their expected controller, we need
      # to make sure they can be found.
      [File.dirname(find_template)]
    end


    def find_template
      params[:view]
    end

    def find_layout(template)
      layout = params[:layout]
      case layout
      when nil, 'true', true
        'application'
      when 'false', false
        false
      else
        layout
      end
    end

    def stub_instance_variables_for!(template, options = { })
      load_stubs(template, options).each do |attr, value|
        instance_variable_set("@#{attr}", value)
        self.class.tap do |c|
          c.send(:attr_reader, attr) unless c.method_defined?(attr) # Don't overwrite an existing method.
          c.send(:helper_method, attr)
        end
      end
    end

    def load_stubs(template, options = { })
      ensure_models_models_are_loaded
      loader = PeekAView::StubLoader.new(stubs_root, options)
      loader.load_common
      loader.load(template)
      loader.stubs
    end

    def stubs_root
      Rails.root + 'test/fixtures/view_stubs'
    end

    def ensure_models_models_are_loaded
      Dir[Rails.root + "app/models/**/*.rb"].each { |f| require f }
    end
  end
end
