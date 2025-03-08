# frozen_string_literal: true

module TcrAgent
  module Agents
    class TcrEnforcerAgent < Sublayer::Agents::Base
      def initialize(implementation_path:, test_path:)
        @implementation_path = implementation_path
        @test_path = test_path
        @goal_reached = false
      end

      trigger_on_files_changed { [@test_path] }

      goal_condition { @goal_reached }

      check_status do
        if `git status --porcelain`.empty?
          @goal_reached = true
        else
          @goal_reached = false
        end
      end

      step do
        all_changes = TcrAgent::Actions::GetChangesAction.new.call

        output = TcrAgent::Generators::ImplementationGenerator.new(
          implementation_dir: @implementation_path,
          test_dir: @test_path,
          test_changes: all_changes
        ).generate

        output.each do |file_update|
          puts "Updating file: #{file_update.file_path} with #{file_update.file_contents}"
          TcrAgent::Actions::WriteFileAction.new(file_path: file_update.file_path, file_contents: file_update.file_contents).call
        end

        stdout, stderr, status = TcrAgent::Actions::RunTestCommandAction.new(command: "rspec #{@test_path}").call
        puts stdout

        if status.exitstatus == 0
          puts "Tests Passed! Committing! (press 'y' to confirm)"
          all_changes = TcrAgent::Actions::GetChangesAction.new.call
          message = TcrAgent::Generators::CommitMessageGenerator.new(changes: all_changes).generate
          puts "Commit Message: #{message}"

          # confirmation = STDIN.gets.chomp

          # if confirmation == 'y' || confirmation == "Y"
            all_changes = TcrAgent::Actions::GetChangesAction.new.call
            message = TcrAgent::Generators::CommitMessageGenerator.new(changes: all_changes).generate

            TcrAgent::Actions::GitCommitAction.new(commit_message: message).call
          # end
        else
          puts "Womp womp, tests failed. Reverting! (press 'f' to pay respects)"
          # confirmation = STDIN.gets.chomp
          # if confirmation == 'f' || confirmation == "F"
            TcrAgent::Actions::GitRevertAction.new.call
          # end
        end
      end
    end
  end
end
