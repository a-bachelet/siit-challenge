require 'json'

require_relative '../models/car'
require_relative '../models/option'
require_relative '../models/rental'
require_relative '../services/payment_service'
require_relative '../validators/car_validator'
require_relative '../validators/data_validator'
require_relative '../validators/option_validator'
require_relative '../validators/rental_validator'

class RentalService
  attr_reader :cars, :rentals

  def initialize(json_data)
    @cars = []
    @rentals = []

    parsed_data = JSON.parse(json_data)

    raise 'Invalid JSON data' unless DataValidator.validate(parsed_data)

    import_cars(parsed_data['cars'])
    import_rentals(parsed_data['rentals'], parsed_data['options'])
  end

  def compute_rentals_options_and_actions
    @rentals.map do |rental|
      { id: rental.id, options: rental.options.map(&:type), actions: PaymentService.compute_payments(rental).map(&:to_h) }
    end
  end

  private

  def import_cars(parsed_cars)
    parsed_cars.each do |car|
      next unless CarValidator.validate(car, @cars.map(&:id))
      @cars << Car.new(car['id'], car['price_per_day'], car['price_per_km'])
    end
  end

  def import_rentals(parsed_rentals, parsed_options)
    parsed_rentals.each do |rental|
      next unless RentalValidator.validate(rental, @cars.map(&:id), @rentals.map(&:id))
      rental_options = import_options(parsed_options, rental['id'], [])
      car = @cars.find { |car| car.id == rental['car_id'] }
      @rentals << Rental.new(rental['id'], car, rental_options, rental['start_date'], rental['end_date'], rental['distance'])
    end
  end

  def import_options(parsed_options, rental_id, rental_options)
    parsed_options.each do |option|
      next unless OptionValidator.validate(option, rental_id, rental_options)
      rental_options << Option.new(option['id'], option['rental_id'], option['type'])
    end

    rental_options
  end

end