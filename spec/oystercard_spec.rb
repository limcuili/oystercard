require 'oystercard'

describe Oystercard do
  it 'checks that Osystercard.new to create new Oyster' do
    expect(Oystercard.new).to be_instance_of Oystercard
  end
  it 'checks that a new oyster has a balance of 0' do
    expect(subject.balance).to eq 0
  end

  describe '#top_up' do
    it { is_expected.to respond_to(:top_up).with(1).argument }

    it 'gives balance 10 when top_up(10) is called on a new card' do
      # within an 'it' block, the first call for subject gives Oystercard.new
      # after that, it is considered an instance.
      subject.top_up(10)
      expect(subject.balance).to eq 10
    end

    it 'can top up any card, new or existing' do
      expect{ subject.top_up(1) }.to change{ subject.balance }.by(1)
    end

    it 'raises an error when top_up(100) is called on a new card' do
      expect{ subject.top_up(100) }.to raise_error 'Error: Card cannot exceed £90'
    end

    it 'raises an error when we top up over the £90 limit on an existing card' do
      subject.top_up(80)
      subject.top_up(10)
      expect{ subject.top_up(1) }.to raise_error 'Error: Card cannot exceed £90'
    end
  end

end
