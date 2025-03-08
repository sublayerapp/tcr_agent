# frozen_string_literal: true

module TcrAgent
  class CLI < Thor
    TcrAgent::Commands.constants.reject{ |command_class| command_class == :BaseCommand }.each do |command_class|
      command = TcrAgent::Commands.const_get(command_class)
      desc command.command_name, command.description
      define_method(command.command_name) do |*args|
        command.new(options).execute(*args)
      end
    end
  end
end
