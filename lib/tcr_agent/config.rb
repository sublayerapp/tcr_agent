module TcrAgent
  module Config
    def self.load
      config_path = File.join(File.dirname(__FILE__), "config", "sublayer.yml")

      if File.exist?(config_path)
        config = YAML.load_file(config_path)

        Sublayer.configure do |c|
          c.ai_provider = Object.const_get("Sublayer::Providers::#{config[:ai_provider]}")
          c.ai_model = config[:ai_model]
        end
      else
        puts "Warning: config/sublayer.yml not found. Using default configuration."
      end
    end
  end
end
