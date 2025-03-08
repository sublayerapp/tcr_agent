# frozen_string_literal: true

module TcrAgent
  module Generators
    class CommitMessageGenerator < Sublayer::Generators::Base
      llm_output_adapter type: :single_string,
        name: "commit_message",
        description: "A commit message to describe the changes made"

      def initialize(changes:)
        @changes = changes
      end

      def prompt
        <<-PROMPT
          You are working on a project using test-driven development with a TCR (test && commit || revert) workflow.

          The tests just passed and we want to write a short commit message describing the changes.

          Your task is to write a commit message that describes the changes made to the implementation files and test files for this latest change.

          The latest diff is:
          #{@changes}
        PROMPT
      end
    end
  end
end
