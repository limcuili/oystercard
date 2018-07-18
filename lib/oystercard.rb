class Oystercard
  attr_reader :balance, :in_journey
  MAX_BALANCE = 90
  MIN_BALANCE = 1
  MIN_FARE = 2.30

  def initialize
    @balance = 0
    @in_journey = false
  end

  def top_up(amount)
    fail "Error: Card cannot exceed £#{MAX_BALANCE}" if (@balance + amount > MAX_BALANCE)
    @balance += amount
    @balance.round(2)
  end

  def touch_in
    fail 'Error: Card has insufficient balance' if (@balance < MIN_BALANCE)
    @in_journey = true
  end

  def touch_out
    deduct(MIN_FARE)
    @in_journey = false
  end

  def in_journey?
    @in_journey
  end

private
  def deduct(amount)
    @balance -= amount
    @balance.round(2)
  end
end
