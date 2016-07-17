require_relative 'twilio_handler'

class Takeaway

  def initialize
    @basket = {}
  end

  def basket
    @basket.dup
  end

  def menu
    {"rice" => 1.49, "pizza" => 3.79, "cheeseburder" => 0.99, "pepsi" => 0.89}
  end

  def add_item(item, quantity = 1)
    fail "Negative or zero quantities not allowed" if quantity <= 0
    fail "#{item} is not on the menu!" if menu[item].nil?
    @basket[item] = quantity
    "#{quantity}x #{item}(s) added to your basket"
  end

  def basket_summary
    lines = []
    @basket.each do |item, quantity|
      lines << "#{item} x#{quantity} = £#{(menu[item] * quantity).round(2)}"
    end
    lines.join(', ')
  end

  def total
    "Total cost: £#{calculate_total}"
  end

  def checkout(amount)
    fail "Your basket is empty!" if @basket.empty?
    fail "Amount given is less than total cost" if amount < calculate_total
    confirm_order
  end

  private

  def calculate_total
    cost = 0
    @basket.each { |item, quantity| cost += menu[item] * quantity }
    cost.round(2)
  end

  def confirm_order
    TwilioHandler.send_message
    "Payment successful! You will receive a text message shortly to confirm" \
    " the order."
  end

end
