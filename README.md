This is Week 2 of Makers.

# oystercard

## Learn debugging basics

I set up my project and created the gemfile needed. I have also created a oystercard_spec.rb and have initialized my describe block. Running rspec in the command line, I got this error:

```
An error occurred while loading ./spec/oystercard_spec.rb.
Failure/Error:
  describe Oystercard do
  
  end

NameError:
  uninitialized constant Oystercard
# ./spec/oystercard_spec.rb:1:in `<top (required)>'
No examples found.


Finished in 0.00052 seconds (files took 0.24432 seconds to load)
0 examples, 0 failures, 1 error occurred outside of examples
```
This is a NameError, in the file path './spec/oystercard_spec.rb', in line number 1.
One way of solving this error would be to define this class and link it to this file, so that Ruby can find it


## The below is to keep track of IRB feature tests
Checks that we've set up the card and are able to top up:  
require './lib/oystercard.rb'  
card = Oystercard.new  
card.balance  
card.top_up(10)  
card.balance

Checks error for topping up over the limit:  
require './lib/oystercard.rb'  
card = Oystercard.new  
card.top_up(80)
card.balance
card.top_up(11)

Checks that we are able to deduct money from the card:
require './lib/oystercard.rb'  
card = Oystercard.new  
card.top_up(20)
card.deduct(2.9)

