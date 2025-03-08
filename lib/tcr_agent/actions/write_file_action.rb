# frozen_string_literal: true

module TcrAgent
  module Actions
    class WriteFileAction < Sublayer::Actions::Base
      def initialize(file_path:, file_contents:)
        @file_path = file_path
        @file_contents = file_contents
      end

      def call
        File.write(@file_path, @file_contents)
      end
    end
  end
end
