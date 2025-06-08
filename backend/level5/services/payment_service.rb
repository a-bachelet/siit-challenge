require_relative '../models/payment'

class PaymentService
  def self.compute_payments(rental)
    amount_from_driver = rental.total_price
    amount_for_owner = rental.total_price_without_options - rental.commission_details[:total_commission] + rental.options_amount_for(Payment::Actor::OWNER)
    amount_for_insurance = rental.commission_details[:insurance_fee] + rental.options_amount_for(Payment::Actor::INSURANCE)
    amount_for_assistance = rental.commission_details[:assistance_fee] + rental.options_amount_for(Payment::Actor::ASSISTANCE)
    amount_for_drivy = rental.commission_details[:drivy_fee] + rental.options_amount_for(Payment::Actor::DRIVY)

    [
      Payment.new(Payment::Actor::DRIVER, Payment::Action::DEBIT, amount_from_driver),
      Payment.new(Payment::Actor::OWNER, Payment::Action::CREDIT, amount_for_owner),
      Payment.new(Payment::Actor::INSURANCE, Payment::Action::CREDIT, amount_for_insurance),
      Payment.new(Payment::Actor::ASSISTANCE, Payment::Action::CREDIT, amount_for_assistance),
      Payment.new(Payment::Actor::DRIVY, Payment::Action::CREDIT, amount_for_drivy)
    ]
  end
end