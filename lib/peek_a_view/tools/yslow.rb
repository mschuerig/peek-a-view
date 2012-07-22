#encoding: utf-8
require 'peek_a_view/tools/checker'

module PeekAView
  module Tools
    class YSlow < Checker

      def check(uri)
        system "phantomjs '#{yslow_script}' -f tap '#{uri}'"
      end

      def report(uri)
        system "phantomjs '#{yslow_script}' -f tap '#{uri}' > '#{report_file(uri)}'"
      end

      private

      def yslow_script
        File.join(PeekAView::Engine.config.root, 'tools', 'yslow.js')
      end

      def report_dir
        File.join(Rails.root, 'reports', 'yslow')
      end

      def report_file(uri)
        report_path(uri, '.tap')
      end
    end
  end
end
