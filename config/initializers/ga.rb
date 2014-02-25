GOOGLE_ANALYTICS_SETTINGS = HashWithIndifferentAccess.new

config = YAML.load_file(Rails.root.join('config', 'ga.yml'))[Rails.env]
GOOGLE_ANALYTICS_SETTINGS.update(config) if config