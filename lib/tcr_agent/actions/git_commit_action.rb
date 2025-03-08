# frozen_string_literal: true
require "tempfile"

module TcrAgent
  module Actions
    class GitCommitAction < Sublayer::Actions::Base
      def initialize(commit_message:)
        @commit_message = commit_message
      end

      def call
        `git add .`
        Tempfile.create('commit_message') do |file|
          file.write(@commit_message)
          file.close
          `git commit -F #{file.path}`
        end
      end
    end
  end
end
