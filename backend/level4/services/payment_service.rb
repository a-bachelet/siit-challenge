require_relative '../models/payment'
require_relative 'price_service'

class PaymentService
  ACTIONS = {
    DEBIT_ACTION: 'debit',
    CREDIT_ACTION: 'credit'
  }.freeze

  ACTORS = {
    DRIVER: 'driver',
    OWNER: 'owner',
    INSURANCE: 'insurance',
    ASSISTANCE: 'assistance',
    DRIVY: 'drivy'
  }.freeze

  def self.compute_actions(rental, car)    
    total_price = PriceService.compute_total_price(rental, car)
    commission = PriceService.compute_commission(rental, car)

    [
      Payment.new(ACTORS[:DRIVER], ACTIONS[:DEBIT_ACTION], total_price),
      Payment.new(ACTORS[:OWNER], ACTIONS[:CREDIT_ACTION], total_price - commission[:total_commission]),
      Payment.new(ACTORS[:INSURANCE], ACTIONS[:CREDIT_ACTION], commission[:insurance_fee]),
      Payment.new(ACTORS[:ASSISTANCE], ACTIONS[:CREDIT_ACTION], commission[:assistance_fee]),
      Payment.new(ACTORS[:DRIVY], ACTIONS[:CREDIT_ACTION], commission[:drivy_fee])
    ]
  end
end