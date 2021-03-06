#encoding: utf-8
require 'peek_a_view/tools/checker'

module PeekAView
  module Tools
    class YSlow < Checker

      def check(uri)
        system "phantomjs '#{yslow_script}' -f plain '#{uri}'"
      end

      def report(uri)
        system "phantomjs '#{yslow_script}' -f junit '#{uri}' > '#{report_file(uri)}'"
      end

      private

      def yslow_script
        File.join(PeekAView::Engine.config.root, 'vendor', 'yslow.js')
      end

      def report_dir
        File.join(Rails.root, 'reports', 'yslow')
      end

      def report_file(uri)
        report_path(uri, '.xml')
      end
    end
  end
end
