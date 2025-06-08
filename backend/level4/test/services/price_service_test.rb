require_relative '../test_helper'
require_relative '../../services/price_service'

describe PriceService do
  describe 'self.compute_rental_price_rate' do
    it 'returns 100% rate for the first day' do
      _(PriceService.compute_rental_price_rate(1)).must_equal 1
    end

    it 'returns 90% rate after the first day and until the end of the fourth day' do
      _(PriceService.compute_rental_price_rate(2)).must_equal 0.9
      _(PriceService.compute_rental_price_rate(3)).must_equal 0.9
      _(PriceService.compute_rental_price_rate(4)).must_equal 0.9
    end

    it 'returns 70% rate after the fourth day and until the end of the tenth day' do
      _(PriceService.compute_rental_price_rate(5)).must_equal 0.7
      _(PriceService.compute_rental_price_rate(6)).must_equal 0.7
      _(PriceService.compute_rental_price_rate(7)).must_equal 0.7
      _(PriceService.compute_rental_price_rate(8)).must_equal 0.7
      _(PriceService.compute_rental_price_rate(9)).must_equal 0.7
      _(PriceService.compute_rental_price_rate(10)).must_equal 0.7
    end

    it 'returns 50% rate after the tenth day' do
      _(PriceService.compute_rental_price_rate(11)).must_equal 0.5
      _(PriceService.compute_rental_price_rate(12)).must_equal 0.5
      _(PriceService.compute_rental_price_rate(13)).must_equal 0.5
      _(PriceService.compute_rental_price_rate(14)).must_equal 0.5
      _(PriceService.compute_rental_price_rate(15)).must_equal 0.5
      # ...
    end
    
  end
  
  describe 'self.compute_distance_price' do
    it 'returns the distance multiplied by the price per km' do
      car = Car.new(id: 1, price_per_day: 2000, price_per_km: 10)
      rental = Rental.new(id: 1, car_id: 1, start_date: Date.parse('2015-12-8'), end_date: Date.parse('2015-12-10'), distance: 100)
      _(PriceService.compute_distance_price(rental, car)).must_equal 1000
    end
  end

  describe 'self.compute_rental_price' do
    it 'returns the computed rental price based on the rate' do
      PriceService.stub :compute_rental_price_rate, 0.1 do
        car = Car.new(id: 1, price_per_day: 2000, price_per_km: 10)
        rental = Rental.new(id: 1, car_id: 1, start_date: Date.parse('2015-12-8'), end_date: Date.parse('2015-12-10'), distance: 100)
        _(PriceService.compute_rental_price(rental, car)).must_equal 600
      end
    end
  end

  describe 'self.compute_total_price' do
    it 'adds the rental and distance prices' do
      PriceService.stub :compute_rental_price, 100 do
        PriceService.stub :compute_distance_price, 200 do
          car = Car.new(id: 1, price_per_day: 2000, price_per_km: 10)
          rental = Rental.new(id: 1, car_id: 1, start_date: Date.parse('2015-12-8'), end_date: Date.parse('2015-12-10'), distance: 100)
          _(PriceService.compute_total_price(rental, car)).must_equal 300
        end
      end
    end
  end

  describe 'self.compute_commission' do
    it 'computes the commission details' do
      car = Car.new(id: 1, price_per_day: 2000, price_per_km: 10)
      rental = Rental.new(id: 1, car_id: 1, start_date: Date.parse('2015-12-8'), end_date: Date.parse('2015-12-8'), distance: 100)
      _(PriceService.compute_commission(rental, car)).must_equal ({
        total_commission: 900,
        insurance_fee: 450,
        assistance_fee: 100,
        drivy_fee: 350,
      })

      car = Car.new(id: 1, price_per_day: 2000, price_per_km: 10)
      rental = Rental.new(id: 1, car_id: 1, start_date: Date.parse('2015-03-31'), end_date: Date.parse('2015-04-01'), distance: 300)
      _(PriceService.compute_commission(rental, car)).must_equal ({
        total_commission: 2040,
        insurance_fee: 1020,
        assistance_fee: 200,
        drivy_fee: 820,
      })

      car = Car.new(id: 1, price_per_day: 2000, price_per_km: 10)
      rental = Rental.new(id: 1, car_id: 1, start_date: Date.parse('2015-07-3'), end_date: Date.parse('2015-07-14'), distance: 1000)
      _(PriceService.compute_commission(rental, car)).must_equal ({
        total_commission: 8340,
        insurance_fee: 4170,
        assistance_fee: 1200,
        drivy_fee: 2970,
      })
    end
  end
end
