require_relative '../test_helper'
require_relative '../../models/option'
require_relative '../../models/payment'
require_relative '../../services/payment_service'
require_relative '../../services/rental_service'

describe RentalService do
  before do
    @json_data = File.read(File.join(File.dirname(__FILE__), '..', '..', 'data', 'input.json'))
  end

  describe 'initialize' do
    it 'raises an error if the JSON data is invalid' do
      DataValidator.stub :validate, false do
        _(-> { RentalService.new(@json_data) }).must_raise 'Invalid JSON data'
      end
    end

    it 'initializes the rental service with the correct data' do
      rental_service = RentalService.new(@json_data)

      _(rental_service.cars.size).must_equal 1
      _(rental_service.rentals.size).must_equal 3
      _(rental_service.rentals[0].options.size).must_equal 2
      _(rental_service.rentals[1].options.size).must_equal 1
      _(rental_service.rentals[2].options.size).must_equal 0

      car = rental_service.cars[0]
      _(car.id).must_equal 1
      _(car.price_per_day).must_equal 2000
      _(car.price_per_km).must_equal 10

      rental1 = rental_service.rentals[0]
      _(rental1.id).must_equal 1
      _(rental1.car).must_equal car
      _(rental1.start_date).must_equal Date.parse('2015-12-8')
      _(rental1.end_date).must_equal Date.parse('2015-12-08')
      _(rental1.distance).must_equal 100
      _(rental1.options.size).must_equal 2
      _(rental1.options[0].type).must_equal Option::Type::GPS
      _(rental1.options[1].type).must_equal Option::Type::BABY_SEAT

      rental2 = rental_service.rentals[1]
      _(rental2.id).must_equal 2
      _(rental2.car).must_equal car
      _(rental2.start_date).must_equal Date.parse('2015-03-31')
      _(rental2.end_date).must_equal Date.parse('2015-04-01')
      _(rental2.distance).must_equal 300
      _(rental2.options.size).must_equal 1
      _(rental2.options[0].type).must_equal Option::Type::ADDITIONAL_INSURANCE

      rental3 = rental_service.rentals[2]
      _(rental3.id).must_equal 3
      _(rental3.car).must_equal car
      _(rental3.start_date).must_equal Date.parse('2015-07-03')
      _(rental3.end_date).must_equal Date.parse('2015-07-14')
      _(rental3.distance).must_equal 1000
      _(rental3.options.size).must_equal 0
    end
  end

  describe 'compute_rentals_details' do
    before do
      @rental_service = RentalService.new(@json_data)
    end

    it 'returns an array containing the options and actions well formed for each rental' do
      rentals_options_and_actions = @rental_service.compute_rentals_options_and_actions
      
      _(rentals_options_and_actions).must_be_instance_of Array
      
      rentals_options_and_actions.each do |rental_options_and_actions|
        _(rental_options_and_actions).must_be_instance_of Hash
        _(rental_options_and_actions.keys).must_equal [:id, :options, :actions]

        _(rental_options_and_actions[:id]).must_be_instance_of Integer
        _(rental_options_and_actions[:options]).must_be_instance_of Array
        _(rental_options_and_actions[:actions]).must_be_instance_of Array

        rental_options_and_actions[:options].each do |option|
          _(option).must_be_instance_of Symbol
          _(Option::TYPES).must_include option
        end

        rental_options_and_actions[:actions].each do |action|
          _(action).must_be_instance_of Hash
          _(action.keys).must_equal [:who, :type, :amount]
          _(action[:who]).must_be_instance_of Symbol
          _(Payment::ACTORS).must_include action[:who]
          _(action[:type]).must_be_instance_of Symbol
          _(Payment::ACTIONS).must_include action[:type]
          _(action[:amount]).must_be_instance_of Integer
        end
      end

      rental1_details = rentals_options_and_actions[0]
      _(rental1_details[:id]).must_equal 1
      _(rental1_details[:options]).must_equal [Option::Type::GPS, Option::Type::BABY_SEAT]
      _(rental1_details[:actions].size).must_equal 5

      rental1_actions = PaymentService.compute_payments(@rental_service.rentals[0])
      _(rental1_details[:actions]).must_equal rental1_actions.map(&:to_h)

      rental2_details = rentals_options_and_actions[1]
      _(rental2_details[:id]).must_equal 2
      _(rental2_details[:options]).must_equal [Option::Type::ADDITIONAL_INSURANCE]
      _(rental2_details[:actions].size).must_equal 5

      rental2_actions = PaymentService.compute_payments(@rental_service.rentals[1])
      _(rental2_details[:actions]).must_equal rental2_actions.map(&:to_h)

      rental3_details = rentals_options_and_actions[2]
      _(rental3_details[:id]).must_equal 3
      _(rental3_details[:options]).must_equal []
      _(rental3_details[:actions].size).must_equal 5

      rental3_actions = PaymentService.compute_payments(@rental_service.rentals[2])
      _(rental3_details[:actions]).must_equal rental3_actions.map(&:to_h)
    end
  end
end