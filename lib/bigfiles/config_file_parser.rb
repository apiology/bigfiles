# frozen_string_literal: true

require 'yaml'

module BigFiles
  # Load configuration from files
  class ConfigFileParser
    attr_reader :project_config_filename

    def initialize(project_config_filename = '.bigfiles.yml')
      @project_config_filename = project_config_filename
    end

    def parse_config_files
      config = {}
      project_config = parse_project_config
      config.merge(project_config)
    end

    private

    def item(raw_project_config, section, key)
      raw_project_config.fetch('bigfiles', {}).fetch(section, {}).fetch(key, nil)
    end

    def top_item(raw_project_config, key)
      raw_project_config.fetch('bigfiles', {}).fetch(key, nil)
    end

    def parse_project_config
      return {} unless File.file? project_config_filename

      project_config = {}
      raw_project_config = YAML.load_file(project_config_filename)
      exclude = item(raw_project_config, 'exclude', 'glob')
      project_config[:exclude] = exclude unless exclude.nil?
      glob = item(raw_project_config, 'include', 'glob')
      project_config[:glob] = glob unless glob.nil?
      num_files = top_item(raw_project_config, 'num_files')
      project_config[:num_files] = num_files unless num_files.nil?
      project_config
    end
  end
end
