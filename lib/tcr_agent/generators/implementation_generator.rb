# frozen_string_literal: true

module TcrAgent
  module Generators
    class ImplementationGenerator < Sublayer::Generators::Base
      llm_output_adapter type: :list_of_named_strings,
        name: "file_updates",
        description: "List of files to update to get the tests to pass",
        item_name: "change",
        attributes: [
          { name: "file_path", description: "Path to the file to update" },
          { name: "file_contents", description: "The updated file contents to get the tests to pass" }
        ]

        def initialize(implementation_dir:, test_dir:, test_changes:)
          @implementation_dir = implementation_dir
          @test_dir = test_dir
          @test_changes = test_changes
        end

        def prompt
          implementation_files = Dir.glob(File.join(@implementation_dir, "**/*")).each_with_object({}) do |path, files|
            files[path] = File.read(path)
          end

          test_files = Dir.glob(File.join(@test_dir, "**/*")).each_with_object({}) do |path, files|
            files[path] = File.read(path)
          end

          <<-PROMPT
          You are working on a project using test-driven development with a TCR (test && commit || revert) workflow.

          You have access to the current implementation files, the test files, and the latest changes to the test files in git diff format.
          Your task is to modify the implementation files to get the newly added or changed tests to pass.

          All The implementation files are:
          #{implementation_files.map { |path, content| "File: #{path}\n#{content}" }.join("\n\n")}

          The test files are:
          #{test_files.map { |path, content| "File: #{path}\n#{content}" }.join("\n\n")}

          And the latest diff to the tests are:
          #{@test_changes}

          Please provide updated versions of any implementation files that need changed to make these new tests pass.
          Focus on minimal, targeted changes that address the specific test changes as we're doing TCR and will need to start over writing new tests if they don't pass.

          Maintain any existing code structure and patterns unless the changes to the tests explicitly require changes.
          PROMPT
        end

    end
  end
end
