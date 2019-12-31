# frozen_string_literal: true

require 'bigfiles/quality_config'

describe BigFiles::QualityConfig do
  let(:quality_config) do
    described_class.new(tool_name,
                        quality_threshold: quality_threshold)
  end

  describe '#under_limit?' do
    subject { quality_config.under_limit?(total_lines) }

    let(:tool_name) { 'bigfiles' }
    let(:quality_threshold) do
      instance_double(BigFiles::QualityThreshold)
    end
    let(:threshold) { 99 }

    before do
      allow(quality_threshold).to receive(:threshold) { threshold }
    end

    context 'when above threshold' do
      let(:total_lines) { 100 }

      it { is_expected.to be false }
    end

    context 'when below threshold' do
      let(:total_lines) { 98 }

      it { is_expected.to be true }
    end

    context 'when at threshold' do
      let(:total_lines) { 99 }

      it { is_expected.to be true }
    end
  end
end
