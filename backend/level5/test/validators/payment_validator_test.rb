require_relative '../test_helper'
require_relative '../../validators/payment_validator'

describe PaymentValidator do
  describe 'self.validate' do
    it 'returns true if the payment data is valid' do
      _(PaymentValidator.validate(Payment::Actor::DRIVER, Payment::Action::DEBIT, 100)).must_equal true
    end

    it 'returns false if the actor is invalid' do
      _(PaymentValidator.validate(:invalid, Payment::Action::DEBIT, 100)).must_equal false
    end

    it 'returns false if the action is invalid' do
      _(PaymentValidator.validate(Payment::Actor::DRIVER, :invalid, 100)).must_equal false
    end
    
    it 'returns false if the amount is not positive' do
      _(PaymentValidator.validate(Payment::Actor::DRIVER, Payment::Action::DEBIT, -100)).must_equal false
    end
  end
end