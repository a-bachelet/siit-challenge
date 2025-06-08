require_relative '../models/payment'

class PaymentValidator
  def self.validate(actor, action, amount)
    return false unless Payment::ACTORS.include?(actor)
    return false unless Payment::ACTIONS.include?(action)
    return false unless amount.is_a?(Numeric) && amount.positive?

    true
  end
end 