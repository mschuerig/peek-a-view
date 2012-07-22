#encoding: utf-8
require 'w3c_validators'
require 'peek_a_view/tools/checker'

module PeekAView
  module Tools
    class HtmlValidator < Checker
      def initialize(options)
        validator_uri = options.delete(:validator_uri)
        raise ArgumentError, "Option validator_uri must be specified" unless validator_uri
        super

        @validator = W3CValidators::NuValidator.new(
          validator_uri: validator_uri,
          charset:       'UTF-8' # somehow the validator does not get this from the response
        )
      end

      def check(uri)
        @validator.validate_uri(uri)
      end

      def report(uri)
        results = check(uri)

        File.open(report_file(uri), 'w') do |out|
          out.puts "*** Valid: #{results.is_valid?}"
          out.puts
          print_hash(out, '*** Errors', results.errors)
          out.puts
          print_hash(out, '*** Warnings', results.warnings)
          out.puts
        end
      end

      private

      def report_dir
        File.join(Rails.root, 'reports', 'html_validator')
      end

      def report_file(uri)
        report_path(uri, '.txt')
      end
    end
  end
end
