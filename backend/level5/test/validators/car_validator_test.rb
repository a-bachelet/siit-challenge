require_relative '../test_helper'
require_relative '../../validators/car_validator'

describe CarValidator do
  describe 'self.validate' do
    it 'returns true if the parsed_car is valid' do
      parsed_car = { 'id' => 1, 'price_per_day' => 100, 'price_per_km' => 10 }
      persisted_car_ids = []
      _(CarValidator.validate(parsed_car, persisted_car_ids)).must_equal true
    end

    it 'returns false if the parsed_car is not a Hash' do
      parsed_car = 'not a hash'
      persisted_car_ids = []
      _(CarValidator.validate(parsed_car, persisted_car_ids)).must_equal false
    end

    it 'returns false if a mandatory key is missing' do
      ['id', 'price_per_day', 'price_per_km'].each do |key|
        parsed_car = { 'id' => 1, 'price_per_day' => 100, 'price_per_km' => 10 }
        parsed_car.delete(key)
        persisted_car_ids = []
        _(CarValidator.validate(parsed_car, persisted_car_ids)).must_equal false
      end
    end

    it 'returns false if a mandatory numeric value is not positive' do
      [
        [1, -1, 10],
        [1, 100, -1],
        [0, 100, 10],
        [0, 'ABCD', 10]
      ].each do |(id, price_per_day, price_per_km)|
        parsed_car = { 'id' => id, 'price_per_day' => price_per_day, 'price_per_km' => price_per_km }
        persisted_car_ids = []
        _(CarValidator.validate(parsed_car, persisted_car_ids)).must_equal false
      end
    end

    it 'returns false if the car ID is already persisted' do
      parsed_car = { 'id' => 1, 'price_per_day' => 100, 'price_per_km' => 10 }
      persisted_car_ids = [1]
      _(CarValidator.validate(parsed_car, persisted_car_ids)).must_equal false
    end
  end
end