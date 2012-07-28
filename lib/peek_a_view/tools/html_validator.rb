#encoding: utf-8
require 'w3c_validators'
require 'peek_a_view/tools/checker'
require 'builder/xmlmarkup'

module PeekAView
  module Tools
    class HtmlValidator < Checker
      def initialize(options)
        validator_uri = options.delete(:validator_uri)
        raise ArgumentError, "Option validator_uri must be specified" unless validator_uri
        super

        # Somehow the validator does not get this from the response
        charset = (options[:charset] || 'UTF-8').upcase

        @validator = W3CValidators::NuValidator.new(
          validator_uri: validator_uri,
          charset:       charset
        )
      end

      def check(uri)
        @validator.validate_uri(uri)
      end

      def report(uri)
        results = check(uri)
        write_report(uri, results)
      end

      private

      def write_report(uri, results)
        xml = Builder::XmlMarkup.new(indent: 2)
        xml.instruct!

        tests    = results.errors.size + results.warnings.size
        failures = results.errors.size

        xml.testsuite(name: "HTML5 Validation for #{uri}", tests: tests, failures: failures) do
          results.errors.each do |error|
            write_testcase(xml, error, 'error')
          end
          results.warnings.each do |warning|
            write_testcase(xml, warning, 'warning')
          end
        end

        File.open(report_file(uri), 'w') do |out|
          out.puts(xml.target!)
        end
      end

      def write_testcase(xml, testcase, status)
        short_message = testcase.message[/^(.{20,}?\.)/, 1]
        xml.testcase(name: short_message, status: status) do
          xml.failure(message: testcase.message) do
            xml.text!("At #{testcase.line}:#{testcase.col}") if testcase.line.present?
            xml.cdata!(testcase.source) if testcase.source.present?
          end
        end
      end

      def report_dir
        File.join(Rails.root, 'reports', 'html_validator')
      end

      def report_file(uri)
        report_path(uri, '.xml')
      end
    end
  end
end
