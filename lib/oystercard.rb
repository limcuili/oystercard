class Oystercard
  attr_reader :balance, :in_journey, :entry_station
  MAX_BALANCE = 90
  MIN_BALANCE = 1
  MIN_FARE = 2.30

  def initialize
    @balance = 0
    @in_journey = false
    @entry_station = nil
  end

  def top_up(amount)
    fail "Error: Card cannot exceed £#{MAX_BALANCE}" if (@balance + amount > MAX_BALANCE)
    @balance += amount
    @balance.round(2)
  end

  def touch_in(entry_station)
    fail 'Error: Card has insufficient balance' if (@balance < MIN_BALANCE)
    @entry_station = entry_station
  end

  def touch_out
    deduct(MIN_FARE)
    @entry_station = nil
  end

  def in_journey?
    !!@entry_station
  end

private
  def deduct(amount)
    @balance -= amount
    @balance.round(2)
  end
end
