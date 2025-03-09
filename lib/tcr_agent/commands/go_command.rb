module TcrAgent
  module Commands
    class GoCommand < BaseCommand
      def self.description
        "A command to activate the TCR agent processing"
      end

      def execute(*args)
        all_changes = TcrAgent::Actions::GetChangesAction.new.call

        output = TcrAgent::Generators::ImplementationGenerator.new(
          implementation_dir: args[0],
          test_dir: args[1],
          test_changes: all_changes
        ).generate

        output.each do |file_update|
          puts "Updating file: #{file_update.file_path} with #{file_update.file_contents}"
          TcrAgent::Actions::WriteFileAction.new(file_path: file_update.file_path, file_contents: file_update.file_contents).call
        end

        stdout, stderr, status = TcrAgent::Actions::RunTestCommandAction.new(command: "rspec #{args[1]}").call
        puts stdout

        if status.exitstatus == 0
          puts "Tests Passed! Committing!"
          all_changes = TcrAgent::Actions::GetChangesAction.new.call
          message = TcrAgent::Generators::CommitMessageGenerator.new(changes: all_changes).generate

          puts "Commit Message: #{message}"

          TcrAgent::Actions::GitCommitAction.new(commit_message: message).call
        else
          puts "Womp womp, tests failed. Reverting! (press 'f' to pay respects)"
          confirmation = STDIN.gets.chomp
          # if confirmation == 'f' || confirmation == "F"
            TcrAgent::Actions::GitRevertAction.new.call
          # end
        end
      end
    end
  end
end
