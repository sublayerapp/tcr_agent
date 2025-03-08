module TcrAgent
  module Commands
    class BaseCommand
      def self.command_name
        name.split("::").last.gsub(/Command$/, '').downcase
      end

      def self.description
        "Description for #{command_name}"
      end

      def initialize(options)
        @options = options
      end

      def execute(*args)
        raise NotImplementedError, "#{self.class} must implement #execute"
      end
    end
  end
end
