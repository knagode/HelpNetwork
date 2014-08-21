class Settings
  cattr_reader :config

  def self.load_config
    data = YAML.load(ERB.new(File.read("#{Rails.root}/config/settings.yml")).result)
    @@config = {}

    self.flatten_keys(data, false) do |key, value|
      @@config[key] = value
    end
  end

  # Search path:
  # [env].[locale].key1.key2...
  # [env].key1.key2...
  def self.get(key)
    if val = @@config["#{Rails.env}.#{I18n.locale}.#{key}".to_sym]
      return val
    end
    @@config["#{Rails.env}.#{key}".to_sym]
  end

  def self.[](key)
    get(key)
  end

  def self.flatten_keys(hash, escape, prev_key=nil, &block)
    hash.each_pair do |key, value|
      curr_key = [prev_key, key].compact.join('.').to_sym
      yield curr_key, value
      self.flatten_keys(value, escape, curr_key, &block) if value.is_a?(Hash)
    end
  end

end
