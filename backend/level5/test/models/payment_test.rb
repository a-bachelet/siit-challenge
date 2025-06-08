require_relative '../test_helper'
require_relative '../../models/payment'

describe Payment do
  describe 'initialize' do
    it 'returns a Payment object' do
      payment = Payment.new(Payment::Actor::OWNER, Payment::Action::CREDIT, 100)
      _(payment).must_be_instance_of Payment
    end

    it 'assigns parameters to instance variables' do
      payment = Payment.new(Payment::Actor::OWNER, Payment::Action::CREDIT, 100)
      _(payment.actor).must_equal Payment::Actor::OWNER
      _(payment.action).must_equal Payment::Action::CREDIT
      _(payment.amount).must_equal 100
    end
  end

  describe 'to_h' do
    it 'returns a hash of the payment' do
      payment = Payment.new(Payment::Actor::OWNER, Payment::Action::CREDIT, 100)
      _(payment.to_h).must_equal({ who: Payment::Actor::OWNER, type: Payment::Action::CREDIT, amount: 100 })
    end
  end
end