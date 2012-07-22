require 'fileutils'
require 'peek_a_view/tools'

module PeekAView
  module Tools
    class Checker

      def initialize(options = {})
        @options = options
      end

      def clean_reports
        FileUtils.rm_rf(report_dir)
      end

      protected

      def print_hash(out, title, hash)
        out.puts title
        hash.each do |k, v|
          out.puts "#{k}: #{v}"
        end
      end

      def report_dir
        raise NotImplementedError,
              "report_dir must be overridden in subclasses of #{self.class}."
      end

      def report_path(uri, ext = nil)
        view   = view_from_uri(uri)
        report = File.join(report_dir, view)
        report += ext if ext
        FileUtils.mkpath(File.dirname(report))
        report
      end

      def view_from_uri(uri)
        PeekAView::Tools.view_from_uri(uri, @options)
      end
    end
  end
end
