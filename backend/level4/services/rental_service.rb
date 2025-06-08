require 'json'

require_relative '../models/car'
require_relative '../models/rental'
require_relative '../validators/data_validator'
require_relative '../validators/car_validator'
require_relative '../validators/rental_validator'
require_relative 'price_service'
require_relative 'payment_service'

class RentalService
  attr_reader :cars, :rentals

  def initialize(json_data)
    @cars = []
    @rentals = []

    parsed_data = JSON.parse(json_data)

    raise 'Invalid JSON data' unless DataValidator.validate(parsed_data)

    import_cars(parsed_data['cars'], @cars.map(&:id))
    import_rentals(parsed_data['rentals'], @cars.map(&:id), @rentals.map(&:id))
  end

  def compute_rentals_price
    @rentals_price ||= @rentals.map do |rental|
      car = @cars.find { |car| car.id == rental.car_id }
      actions = PaymentService.compute_actions(rental, car)

      { id: rental.id, actions: actions.map(&:to_h) }
    end
  end

  private

  def import_cars(parsed_cars, car_ids)
    parsed_cars
      .filter { CarValidator.validate(_1, car_ids) }
      .each { @cars << Car.new(**_1) }
  end

  def import_rentals(parsed_rentals, car_ids, rental_ids)
    parsed_rentals
    .filter { RentalValidator.validate(_1, car_ids, rental_ids) }
    .each { @rentals << Rental.new(**_1, start_date: Date.parse(_1['start_date']), end_date: Date.parse(_1['end_date'])) }
  end

end