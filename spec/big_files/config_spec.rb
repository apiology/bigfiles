describe BigFiles::Config do
  describe '#under_limit?' do
    subject { config.under_limit?(num_lines) }

    let(:config) { described_class.new(quality_config: quality_config) }
    let(:quality_config) { instance_double(BigFiles::QualityConfig) }
    let(:under_limit_result) { instance_double(Object) }
    let(:num_lines) { instance_double(Integer) }

    before do
      allow(quality_config).to receive(:under_limit?).with(num_lines) do
        under_limit_result
      end
    end

    it { is_expected.to eq(under_limit_result) }
  end
end
