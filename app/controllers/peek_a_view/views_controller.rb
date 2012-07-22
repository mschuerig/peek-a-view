module PeekAView
  class ViewsController < ActionController::Base

    def index
      PeekAView.load_views
      @views = config.views.keys.sort
      respond_to do |format|
        format.html do
          render template: '/peek_a_view/views/index'
        end
        format.json do
          absolute = {
            protocol: request.protocol,
            host:     request.host,
            port:     request.port
          }
          render json: @views.map { |v| peek_a_view_engine.view_url(v, absolute) }
        end
      end
    end

    def show
      PeekAView.load_views

      if (view = find_view)
        render_template(view, params)
      else
        render text: "No such template", status: :not_found
      end
    end


    def url_options
      # Substitute stubbed params for URL generation.
      { _path_segments: @params }
    end

    hide_action :url_options

    private

    def config
      PeekAView::Engine.config.peek_a_view
    end

    def find_view
      config.views[params[:view]]
    end

    def render_template(view, params)
      flash[:alert]  = params[:flash_alert]
      flash[:notice] = params[:flash_notice]

      template = view.template

      stub_instance_variables_for!(view, variant: params[:variant])
      render template: template, layout: find_layout(view)
    end

    def _prefixes
      return super unless params[:action] == 'show'
      # Fake the path prefix for partials specified only with a relative path.
      # As we are not rendering them with their expected controller, we need
      # to make sure they can be found.
      [File.dirname(params[:view])]
    end

    def find_layout(view)
      layout = params[:layout]
      case layout
      when 'true', true
        'application'
      when 'false', false
        false
      when nil
        view.layout
      else
        layout
      end
    end

    def stub_instance_variables_for!(view, options)
      view.variables(options).each do |attr, value|
        instance_variable_set("@#{attr}", value)
        self.singleton_class.tap do |c|
          c.send(:attr_reader, attr) unless c.method_defined?(attr) # Don't overwrite an existing method.
          c.send(:helper_method, attr)
        end
      end
    end
  end
end
