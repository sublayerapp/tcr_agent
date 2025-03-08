# frozen_string_literal: true

module TcrAgent
  module Actions
    class GitRevertAction < Sublayer::Actions::Base
      def call
        `git add -N .`
        `git reset --hard HEAD`
      end
    end
  end
end
