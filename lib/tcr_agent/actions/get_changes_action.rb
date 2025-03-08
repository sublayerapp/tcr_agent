# frozen_string_literal: true

module TcrAgent
  module Actions
    class GetChangesAction < Sublayer::Actions::Base
      def call
        tracked_changes = `git diff`
        untracked_files = `git ls-files --others --exclude-standard`

        unless untracked_files.empty?
          `git add -N .`
          untracked_changes = `git diff`
          `git reset`
        else
          untracked_changes = ""
        end

        return tracked_changes + untracked_changes
      end
    end
  end
end
