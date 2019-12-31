# frozen_string_literal: true

require_relative 'quality_threshold'

module BigFiles
  # Configuration of quality gem
  class QualityConfig
    def initialize(tool_name,
                   quality_threshold: QualityThreshold.new(tool_name))
      @quality_threshold = quality_threshold
    end

    def under_limit?(total_lines)
      total_lines <= @quality_threshold.threshold
    end
  end
end
