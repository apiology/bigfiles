# -*- coding: utf-8 -*-
require 'spec_helper'
require 'bigfiles'

describe BigFiles do
  subject(:io) { double('io') }
  subject(:exiter) { double('exiter') }
  subject(:bigfiles) do
    BigFiles.new(args,
                 io: io,
                 exiter: exiter)
  end

  context 'With no arguments' do
    subject(:args) { [''] }
    describe '#new' do
      it 'should initialize' do
        subject
      end
    end

    describe '.run' do
      it 'should run' do
        bigfiles.run
      end
    end
  end

  context 'With help argument' do
    subject(:args) { ['-h'] }
    describe '.run' do
      it 'should offer help' do
        expect(io).to receive(:puts)
        expect(exiter).to receive(:exit)
        bigfiles.run
      end
    end
  end
end
