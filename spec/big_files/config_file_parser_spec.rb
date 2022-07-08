# frozen_string_literal: true

require 'bigfiles/config_file_parser'

describe BigFiles::ConfigFileParser do
  let(:config_file_parser) { described_class.new(file_class: file_class, yaml_class: yaml_class) }

  let(:yaml_class) { class_double(YAML, 'yaml_class') }

  let(:file_class) { class_double(File, 'file_class') }

  describe '#parse_config_files when no file exists' do
    subject { config_file_parser.parse_config_files }

    before do
      allow(file_class).to receive(:file?).with('.bigfiles.yml').and_return(false)
    end

    it { is_expected.to eq({}) }
  end

  describe '#parse_config_files when file exists' do
    subject { config_file_parser.parse_config_files }

    before do
      allow(file_class).to receive(:file?).with('.bigfiles.yml').and_return(true)
      allow(yaml_class).to receive(:load_file).with('.bigfiles.yml').and_return(parsed_config_file)
    end

    context 'when empty' do
      let(:parsed_config_file) do
        {}
      end

      it { is_expected.to eq({}) }
    end

    context 'when fully populated' do
      let(:parsed_config_file) do
        {
          'bigfiles' => {
            'num_files' => 23,
            'include' => {
              'glob' => '**/*.{rb,sh}',
            },
            'exclude' => {
              'glob' => 'fix.sh',
            },
          },
        }
      end

      it { is_expected.to eq({ exclude: 'fix.sh', glob: '**/*.{rb,sh}', num_files: 23 }) }
    end
  end
end
