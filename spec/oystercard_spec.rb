require 'oystercard'

describe Oystercard do

  let(:entry_station){double :entry_station}
  let(:exit_station){double :exit_station}

  it 'checks that Osystercard.new to create new Oyster' do
    expect(Oystercard.new).to be_instance_of Oystercard
  end
  it 'checks that a new oyster has a balance of 0' do
    expect(subject.balance).to eq 0
  end

  describe '#top_up' do
    it { is_expected.to respond_to(:top_up).with(1).argument }

    it 'ensures that we top up to 2 decimal places' do
      expect(subject.top_up(1.999999)).to eq 2
    end

    it 'gives balance 10 when top_up(10) is called on a new card' do
      # within an 'it' block, the first call for subject gives Oystercard.new
      # after that, it is considered an instance.
      subject.top_up(10)
      expect(subject.balance).to eq 10
    end

    it 'can top up any card, new or existing' do
      expect{ subject.top_up(1) }.to change{ subject.balance }.by(1)
    end

    max_balance = Oystercard::MAX_BALANCE

    it 'raises an error when top_up(100) is called on a new card' do
      expect{ subject.top_up(max_balance + 10) }.to raise_error "Error: Card cannot exceed £#{max_balance}"
    end

    it 'raises an error when we top up over the £90 limit on an existing card' do
      subject.top_up(max_balance)
      expect{ subject.top_up(1) }.to raise_error "Error: Card cannot exceed £#{max_balance}"
    end
  end

  # describe '#deduct' do
  #   it { is_expected.to respond_to(:deduct).with(1).argument }
  #
  #   it 'ensures that we deduct to 2 decimal places' do
  #     subject.top_up(10)
  #     expect(subject.deduct(1.99999999999)).to eq 8
  #   end
  #
  #   it 'can deduct £2.90 from an existing card of balance 20' do
  #     subject.top_up(20)
  #     expect(subject.deduct(2.90)).to eq (20 - 2.90)
  #   end
  #
  #   it 'changes the balance by a negative amount' do
  #     subject.top_up(15)
  #     expect{ subject.deduct(5.17) }.to change{ subject.balance}.by(-5.17)
  #   end
  # end

  describe '#touch_in(entry_station), #in_journey?, #touch_out' do
    it { is_expected.to respond_to(:touch_in).with(1).argument }
    it { is_expected.to respond_to(:in_journey?) }
    it { is_expected.to respond_to(:touch_out).with(1).argument }

    context 'new card' do
      it 'gives an error when a new card of balance 0 is touched in' do
        expect{ subject.touch_in(entry_station) }.to raise_error 'Error: Card has insufficient balance'
      end

      it 'is initially not in journey' do
        expect(subject).not_to be_in_journey
      end
    end

    context 'a card with £5 balance' do
      before do
        subject.top_up(5)
      end

      it 'gives an error when an existing card of balance 0.5 is touched in' do

        subject.top_up(-4.5)
        expect{ subject.touch_in(entry_station) }.to raise_error 'Error: Card has insufficient balance'
      end

      it 'is in journey once we have touched in' do
        subject.touch_in(entry_station)
        expect(subject).to be_in_journey
      end

      it 'is not in journey once we have touched out' do
        subject.touch_in(entry_station)
        subject.touch_out(exit_station)
        expect(subject).not_to be_in_journey
      end

      it 'deducts the minimum fare from your card when you touch out' do
        minimum_fare = Oystercard::MIN_FARE
        expect{ subject.touch_out(exit_station) }.to change{ subject.balance }.by(-minimum_fare)
      end

      it 'expects the card to remember the entry station after touch in' do
        subject.touch_in(entry_station)
        expect(subject).to be_in_journey
      end

      it 'Make the station forget the entry station after touch out' do
        subject.touch_in(entry_station)
        subject.touch_out(exit_station)
        expect(subject).not_to be_in_journey
      end
    end
  end

  describe '#history' do
    it { is_expected.to respond_to(:history) }

    it 'initialize with an empty arrary' do
      expect(subject.history).to be_a(Array)
    end

    context 'a card with £5 balance' do
      before do
        subject.top_up(5)
      end

      it 'print out a single journey history' do
        subject.touch_in('abc')
        subject.touch_out('def')
        expect { subject.history }.to output("1. abc - def\n").to_stdout
      end
    end
  end

end
