# frozen_string_literal: true

require "open3"

module TcrAgent
  module Actions
    class RunTestCommandAction < Sublayer::Actions::Base
      def initialize(command:)
        @command = command
      end

      def call
        stdout, stderr, status = Open3.capture3(@command)
        [stdout, stderr, status]
      end
    end
  end
end
