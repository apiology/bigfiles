describe BigFiles::Config do
  let(:quality_threshold) { instance_double(Quality::Threshold) }
  let(:config) { described_class.new(quality_threshold: quality_threshold) }

  before do
    allow(quality_threshold).to receive(:threshold) { high_water_mark }
  end

  describe '#high_water_mark' do
    subject { config.high_water_mark }

    let(:high_water_mark) { instance_double(Integer) }

    it { is_expected.to eq(high_water_mark) }
  end

  describe '#under_limit? when threshold nil' do
    subject { config.under_limit?(total_lines) }

    let(:high_water_mark) { nil }

    context 'when above threshold' do
      let(:total_lines) { 301 }

      it { is_expected.to be false }
    end

    context 'when below threshold' do
      let(:total_lines) { 299 }

      it { is_expected.to be true }
    end

    context 'when at threshold' do
      let(:total_lines) { 300 }

      it { is_expected.to be true }
    end
  end

  describe '#under_limit? when threshold set' do
    subject { config.under_limit?(total_lines) }

    let(:high_water_mark) { 99 }

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
