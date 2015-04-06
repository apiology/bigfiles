require_relative 'feature_helper'

# http://www.puzzlenode.com/puzzles/13-chess-validator

describe 'Chess validator' do
  it 'starts up with no arguments' do
    expect(exec_io 'bigfiles -h')
      .to eq("USAGE: bigfiles [-n <top n files>]\n")
  end

  # simple complex_1 complex_2 complex_3 complex_4 complex_5 extra
  %w(nofiles).each do |type|
    it "handles #{type} case" do
      expect(exec_io "cd spec/samples/#{type} &&" \
                     'bigfiles -n 3')
        .to eq(IO.read("spec/expected/#{type}_results.txt"))
    end
  end
end
