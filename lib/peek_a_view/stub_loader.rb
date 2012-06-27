module PeekAView

  class StubLoader
    attr_reader :stubs

    def initialize(root, options)
      @root    = root
      @variant = options[:variant].presence
      @stubs   = { }
    end

    def load(file)
      path = @current_path = stubs_path(file)
      if path
        yaml = ERB.new(IO.read(path)).result(binding)
        data = YAML.load(yaml)
        unless data.is_a?(Hash)
          raise ArgumentError, "View stubs #{file} must contain a hash, instead it contains a #{data.class}."
        end
        data.symbolize_keys!
        @stubs.merge!(data)
      end
    ensure
      @current_path = nil
    end

    def load_common
      Dir.chdir(@root) do
        Dir['common/**/*.yml'].each do |s|
          load(s)
        end
      end
    end

    def include_file(file)
      # TODO relative to @current_path
      path = stubs_path(file)
      if path
        data = File.read(path)
        "!!binary |\n    #{[data].pack('m0')}\n"
      else
        raise ArgumentError, "Included file #{file} does not exist."
      end
    end

    def include_yaml(file)
      # TODO relative to @current_path
      path = stubs_path(file)
      if path
        File.read(path)
      else
        raise ArgumentError, "Included YAML file #{file} does not exist."
      end
    end

    private

    def stubs_path(file)
      ext = File.extname(file).presence
      file = file[0..(-1 - ext.length)] if ext
      ext  ||= '.yml'
      base = File.join(@root, file)

      paths = []
      paths << "#{base}.#{@variant}#{ext}" if @variant
      paths << "#{base}#{ext}"

      paths.find { |p| File.file?(p) }
    end
  end
end
