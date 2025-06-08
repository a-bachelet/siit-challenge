require_relative '../test_helper'
require_relative '../../validators/rental_validator'

describe RentalValidator do
  describe 'self.validate' do
    it 'returns true if the parsed_rental is valid' do
      parsed_rental = { 'id' => 1, 'car_id' => 1, 'start_date' => '2021-01-01', 'end_date' => '2021-01-02', 'distance' => 100 }
      persisted_car_ids = [1]
      persisted_rental_ids = []
      _(RentalValidator.validate(parsed_rental, persisted_car_ids, persisted_rental_ids)).must_equal true
    end

    it 'returns false if the parsed_rental is not a Hash' do
      parsed_rental = 'not a hash'
      persisted_car_ids = [1]
      persisted_rental_ids = []
      _(RentalValidator.validate(parsed_rental, persisted_car_ids, persisted_rental_ids)).must_equal false
    end
    
    it 'returns false if a mandatory key is missing' do
      ['id', 'car_id', 'start_date', 'end_date', 'distance'].each do |key|
        parsed_rental = { 'id' => 1, 'car_id' => 1, 'start_date' => '2021-01-01', 'end_date' => '2021-01-02', 'distance' => 100 }
        parsed_rental.delete(key)
        persisted_car_ids = [1]
        persisted_rental_ids = []
        _(RentalValidator.validate(parsed_rental, persisted_car_ids, persisted_rental_ids)).must_equal false
      end
    end

    it 'returns false if a mandatory numeric value is not positive' do
      [
        [1, -1, 100, '2021-01-01', '2021-01-02'],
        [1, 1, -100, '2021-01-01', '2021-01-02'],
        [-1, 1, 100, '2021-01-01', '2021-01-02'],
        [1, 1, 'ABCD', '2021-01-01', '2021-01-02']
      ].each do |(id, car_id, distance, start_date, end_date)|
        parsed_rental = { 'id' => id, 'car_id' => car_id, 'distance' => distance, 'start_date' => start_date, 'end_date' => end_date }
        persisted_car_ids = [1]
        persisted_rental_ids = []
        _(RentalValidator.validate(parsed_rental, persisted_car_ids, persisted_rental_ids)).must_equal false
      end
    end

    it 'returns false if the rental ID is already persisted' do
      parsed_rental = { 'id' => 1, 'car_id' => 1, 'start_date' => '2021-01-01', 'end_date' => '2021-01-02', 'distance' => 100 }
      persisted_car_ids = [1]
      persisted_rental_ids = [1]
      _(RentalValidator.validate(parsed_rental, persisted_car_ids, persisted_rental_ids)).must_equal false
    end
    
    it 'returns false if the car ID is not persisted' do
      parsed_rental = { 'id' => 1, 'car_id' => 1, 'start_date' => '2021-01-01', 'end_date' => '2021-01-02', 'distance' => 100 }
      persisted_car_ids = []
      persisted_rental_ids = []
      _(RentalValidator.validate(parsed_rental, persisted_car_ids, persisted_rental_ids)).must_equal false
    end

    it 'returns false if the start date is not a valid date' do
      parsed_rental = { 'id' => 1, 'car_id' => 1, 'start_date' => 'INVALID DATE', 'end_date' => '2021-01-02', 'distance' => 100 }
      persisted_car_ids = [1]
      persisted_rental_ids = []
      _(RentalValidator.validate(parsed_rental, persisted_car_ids, persisted_rental_ids)).must_equal false
    end

    it 'returns false if the end date is not a valid date' do
      parsed_rental = { 'id' => 1, 'car_id' => 1, 'start_date' => '2021-01-01', 'end_date' => 'INVALID DATE', 'distance' => 100 }
      persisted_car_ids = [1]
      persisted_rental_ids = []
      _(RentalValidator.validate(parsed_rental, persisted_car_ids, persisted_rental_ids)).must_equal false
    end

    it 'returns false if the start date is after the end date' do
      parsed_rental = { 'id' => 1, 'car_id' => 1, 'start_date' => '2021-01-02', 'end_date' => '2021-01-01', 'distance' => 100 }
      persisted_car_ids = [1]
      persisted_rental_ids = []
      _(RentalValidator.validate(parsed_rental, persisted_car_ids, persisted_rental_ids)).must_equal false
    end
  end
end