require_relative '../test_helper'
require_relative '../../models/rental'

describe Rental do
  describe 'initialize' do
    it 'returns a Rental object' do
      car = Car.new(1, 100, 10)
      options = [Option.new(1, 1, 'gps')]
      rental = Rental.new(1, car, options, '2020-01-01', '2020-01-01', 100)
      _(rental).must_be_instance_of Rental
    end

    it 'assigns parameters to instance variables' do
      car = Car.new(1, 100, 10)
      options = [Option.new(1, 1, 'gps')]
      rental = Rental.new(1, car, options, '2020-01-01', '2020-01-01', 100)
      _(rental.id).must_equal 1
      _(rental.car).must_equal car
      _(rental.options).must_equal options
      _(rental.start_date).must_equal Date.new(2020, 1, 1)
      _(rental.end_date).must_equal Date.new(2020, 1, 1)
      _(rental.distance).must_equal 100
    end
  end

  describe 'self.duration_price_rate' do
    it 'returns the price rate for the current duration' do
      _(Rental.duration_price_rate(1)).must_equal 1
      _(Rental.duration_price_rate(2)).must_equal 0.9
      _(Rental.duration_price_rate(4)).must_equal 0.9
      _(Rental.duration_price_rate(5)).must_equal 0.7
      _(Rental.duration_price_rate(10)).must_equal 0.7
      _(Rental.duration_price_rate(11)).must_equal 0.5
      _(Rental.duration_price_rate(100)).must_equal 0.5
    end
  end

  describe 'days' do
    it 'returns the number of days between the start and end dates, including the start date' do
      [
        ['2020-01-01', '2020-01-03', 3],
        ['2023-04-01', '2023-04-15', 15],
        ['2024-12-21', '2025-01-10', 21],
      ].each do |(start_date, end_date, days)|
        rental = Rental.new(1, Car.new(1, 100, 10), [], start_date, end_date, 100)
        _(rental.days).must_equal days
      end
    end
  end

  describe 'duration_price' do
    it 'returns the duration price for the rental' do
      [
        [100, '2020-01-01', '2020-01-03', 280],
        [300, '2023-04-01', '2023-04-15', 3120],
        [200, '2024-12-21', '2025-01-10', 2680],
      ].each do |(price_per_day, start_date, end_date, duration_price)|
        rental = Rental.new(1, Car.new(1, price_per_day, 10), [], start_date, end_date, 100)
        _(rental.duration_price).must_equal duration_price
      end
    end
  end

  describe 'distance_price' do
    it 'returns the distance price for the rental' do
      [
        [10, 100, 1000],
        [20, 300, 6000],
        [5, 750, 3750],
      ].each do |(price_per_km, distance, distance_price)|
        rental = Rental.new(1, Car.new(1, 100, price_per_km), [], '2020-01-01', '2020-01-03', distance)
        _(rental.distance_price).must_equal distance_price
      end
    end
  end

  describe 'options_price' do
    it 'returns the options price for the rental' do
      [
        [[Option.new(1, 1, 'gps')], 1500],
        [[Option.new(1, 1, 'gps'), Option.new(2, 1, 'baby_seat')], 2100],
        [[Option.new(1, 1, 'gps'), Option.new(2, 1, 'baby_seat'), Option.new(3, 1, 'additional_insurance')], 5100],
        [[Option.new(1, 1, 'gps'), Option.new(2, 1, 'additional_insurance')], 4500],
        [[Option.new(2, 1, 'baby_seat'), Option.new(2, 1, 'additional_insurance')], 3600],
      ].each do |(options, options_price)|
        rental = Rental.new(1, Car.new(1, 100, 10), options, '2020-01-01', '2020-01-03', 100)
        _(rental.options_price).must_equal options_price
      end
    end
  end

  describe 'total_price' do
    it 'returns the total price for the rental' do
      [
        [100, 10, '2020-01-01', '2020-01-03', 100, [Option.new(1, 1, 'gps')], 2780],
        [300, 20, '2023-04-01', '2023-04-15', 300, [Option.new(1, 1, 'gps'), Option.new(2, 1, 'baby_seat')], 19620],
        [200, 5, '2024-12-21', '2025-01-10', 750, [Option.new(1, 1, 'baby_seat'), Option.new(2, 1, 'additional_insurance')], 31630],
      ].each do |(price_per_day, price_per_km, start_date, end_date, distance, options, total_price)|
        rental = Rental.new(1, Car.new(1, price_per_day, price_per_km), options, start_date, end_date, distance)
        _(rental.total_price).must_equal total_price
      end
    end
  end

  describe 'total_price_without_options' do
    it 'returns the total price for the rental without options' do
      [
        [100, 10, '2020-01-01', '2020-01-03', 100, [Option.new(1, 1, 'gps')], 1280],
        [300, 20, '2023-04-01', '2023-04-15', 300, [Option.new(1, 1, 'gps'), Option.new(2, 1, 'baby_seat')], 9120],
        [200, 5, '2024-12-21', '2025-01-10', 750, [Option.new(1, 1, 'baby_seat'), Option.new(2, 1, 'additional_insurance')], 6430],
      ].each do |(price_per_day, price_per_km, start_date, end_date, distance, options, total_price_without_options)|
        rental = Rental.new(1, Car.new(1, price_per_day, price_per_km), options, start_date, end_date, distance)
        _(rental.total_price_without_options).must_equal total_price_without_options
      end
    end
  end

  describe 'commission_details' do
    it 'returns the commission details for the rental' do
      [
        [500, 10, '2020-01-01', '2020-01-03', 100, [Option.new(1, 1, 'gps')], {
          total_commission: 720,
          insurance_fee: 360,
          assistance_fee: 300,
          drivy_fee: 60
        }],
        [500, 20, '2023-04-01', '2023-04-15', 300, [Option.new(1, 1, 'gps'), Option.new(2, 1, 'baby_seat')], {
          total_commission: 3360,
          insurance_fee: 1680,
          assistance_fee: 1500,
          drivy_fee: 180
        }],
        [500, 90, '2024-12-21', '2025-01-10', 750, [Option.new(1, 1, 'baby_seat'), Option.new(2, 1, 'additional_insurance')], {
          total_commission: 22260,
          insurance_fee: 11130,
          assistance_fee: 2100,
          drivy_fee: 9030
        }],
      ].each do |(price_per_day, price_per_km, start_date, end_date, distance, options, commission_details)|
        rental = Rental.new(1, Car.new(1, price_per_day, price_per_km), options, start_date, end_date, distance)
        _(rental.commission_details).must_equal commission_details
      end
    end
  end

  describe 'option' do
    it 'returns the option for the rental' do
      gps = Option.new(1, 1, Option::Type::GPS)
      baby_seat = Option.new(2, 1, Option::Type::BABY_SEAT)
      additional_insurance = Option.new(3, 1, Option::Type::ADDITIONAL_INSURANCE)

      rental = Rental.new(1, Car.new(1, 100, 10), [gps, baby_seat, additional_insurance], '2020-01-01', '2020-01-03', 100)
      
      _(rental.option(Option::Type::GPS)).must_equal gps
      _(rental.option(Option::Type::BABY_SEAT)).must_equal baby_seat
      _(rental.option(Option::Type::ADDITIONAL_INSURANCE)).must_equal additional_insurance
    end
  end

  describe 'options_amount_for' do
    it 'returns the amount for the options for the actor' do
      gps = Option.new(1, 1, Option::Type::GPS)
      baby_seat = Option.new(2, 1, Option::Type::BABY_SEAT)
      additional_insurance = Option.new(3, 1, Option::Type::ADDITIONAL_INSURANCE)

      rental = Rental.new(1, Car.new(1, 100, 10), [gps, baby_seat, additional_insurance], '2020-01-01', '2020-01-03', 100)
      
      _(rental.options_amount_for(Payment::Actor::OWNER)).must_equal 2100
    end
  end
end