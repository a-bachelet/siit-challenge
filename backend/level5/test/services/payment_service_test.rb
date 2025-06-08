require_relative '../test_helper'
require_relative '../../services/payment_service'

describe PaymentService do
  describe 'self.compute_payments' do
    it 'computes the payments for the rental' do
      car = Car.new(1, 2000, 10)

      rental1 = Rental.new(1, car, [Option.new(1, 1, Option::Type::GPS), Option.new(2, 1, Option::Type::BABY_SEAT)], '2015-12-8', '2015-12-8', 100)
      rental2 = Rental.new(2, car, [Option.new(3, 2, Option::Type::ADDITIONAL_INSURANCE)], '2015-03-31', '2015-04-01', 300)
      rental3 = Rental.new(3, car, [], '2015-07-3', '2015-07-14', 1000)

      rental1_payments = PaymentService.compute_payments(rental1)
      rental2_payments = PaymentService.compute_payments(rental2)
      rental3_payments = PaymentService.compute_payments(rental3)

      rental1_payments.tap do |payments|
        _(payments.size).must_equal 5
        _(payments.map(&:actor)).must_equal [Payment::Actor::DRIVER, Payment::Actor::OWNER, Payment::Actor::INSURANCE, Payment::Actor::ASSISTANCE, Payment::Actor::DRIVY]
        _(payments.map(&:action)).must_equal [Payment::Action::DEBIT, Payment::Action::CREDIT, Payment::Action::CREDIT, Payment::Action::CREDIT, Payment::Action::CREDIT]
        _(payments.map(&:amount)).must_equal [3700, 2800, 450, 100, 350]
      end

      rental2_payments.tap do |payments|
        _(payments.size).must_equal 5
        _(payments.map(&:actor)).must_equal [Payment::Actor::DRIVER, Payment::Actor::OWNER, Payment::Actor::INSURANCE, Payment::Actor::ASSISTANCE, Payment::Actor::DRIVY]
        _(payments.map(&:action)).must_equal [Payment::Action::DEBIT, Payment::Action::CREDIT, Payment::Action::CREDIT, Payment::Action::CREDIT, Payment::Action::CREDIT]
        _(payments.map(&:amount)).must_equal [8800, 4760, 1020, 200, 2820]
      end
      
      rental3_payments.tap do |payments|
        _(payments.size).must_equal 5
        _(payments.map(&:actor)).must_equal [Payment::Actor::DRIVER, Payment::Actor::OWNER, Payment::Actor::INSURANCE, Payment::Actor::ASSISTANCE, Payment::Actor::DRIVY]
        _(payments.map(&:action)).must_equal [Payment::Action::DEBIT, Payment::Action::CREDIT, Payment::Action::CREDIT, Payment::Action::CREDIT, Payment::Action::CREDIT]
        _(payments.map(&:amount)).must_equal [27800, 19460, 4170, 1200, 2970]
      end
    end
  end
end