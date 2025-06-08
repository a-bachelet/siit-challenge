require_relative '../test_helper'
require_relative '../../validators/data_validator'

describe DataValidator do
  describe 'self.validate' do
    it 'returns true if the parsed_data is valid' do
      parsed_data = { 'cars' => [], 'rentals' => [], 'options' => [] }
      _(DataValidator.validate(parsed_data)).must_equal true
    end

    it 'returns false if the parsed_data is not a Hash' do
      parsed_data = 'not a hash'
      _(DataValidator.validate(parsed_data)).must_equal false
    end

    it 'returns false if a mandatory key is missing' do
      ['cars', 'rentals', 'options'].each do |key|
        parsed_data = { 'cars' => [], 'rentals' => [], 'options' => [] }
        parsed_data.delete(key)
        _(DataValidator.validate(parsed_data)).must_equal false
      end
    end

    it 'returns false if a mandatory array value is not an array' do
      ['cars', 'rentals', 'options'].each do |key|
        parsed_data = { 'cars' => [], 'rentals' => [], 'options' => [] }
        parsed_data[key] = 'not an array'
        _(DataValidator.validate(parsed_data)).must_equal false
      end
    end
  end
end