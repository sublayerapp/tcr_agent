require "yaml"
require "thor"
require "sublayer"
require_relative "tcr_agent/version"
require_relative "tcr_agent/config"

Dir[File.join(__dir__, "tcr_agent", "commands", "*.rb")].each { |file| require file }
Dir[File.join(__dir__, "tcr_agent", "generators", "*.rb")].each { |file| require file }
Dir[File.join(__dir__, "tcr_agent", "actions", "*.rb")].each { |file| require file }
Dir[File.join(__dir__, "tcr_agent", "agents", "*.rb")].each { |file| require file }

require_relative "tcr_agent/cli"

module TcrAgent
  class Error < StandardError; end
  Config.load

  def self.root
    File.dirname __dir__
  end
end
