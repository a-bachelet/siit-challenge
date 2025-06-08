require_relative '../test_helper'
require_relative '../../validators/option_validator'

describe OptionValidator do
  describe 'self.validate' do
    it 'returns true if the parsed_option is valid' do
      parsed_option = { 'id' => 1, 'rental_id' => 1, 'type' => 'gps' }
      current_rental_id = 1
      current_rental_options = []
      _(OptionValidator.validate(parsed_option, current_rental_id, current_rental_options)).must_equal true
    end

    it 'returns false if the parsed_option is not a Hash' do
      parsed_option = 'not a hash'
      current_rental_id = 1
      current_rental_options = []
      _(OptionValidator.validate(parsed_option, current_rental_id, current_rental_options)).must_equal false
    end
    
    it 'returns false if a mandatory key is missing' do
      ['id', 'rental_id', 'type'].each do |key|
        parsed_option = { 'id' => 1, 'rental_id' => 1, 'type' => 'gps' }
        parsed_option.delete(key)
        current_rental_id = 1
        current_rental_options = []
        _(OptionValidator.validate(parsed_option, current_rental_id, current_rental_options)).must_equal false
      end
    end

    it 'returns false if a mandatory numeric value is not positive' do
      [
        [1, -1, 'gps'],
        [0, 1, 'gps'],
        [1, 'ABCD', 'gps']
      ].each do |(id, rental_id, type)|
        parsed_option = { 'id' => id, 'rental_id' => rental_id, 'type' => type }
        current_rental_id = 1
        current_rental_options = []
        _(OptionValidator.validate(parsed_option, current_rental_id, current_rental_options)).must_equal false
      end
    end

    it 'returns false if the option is not for the current rental' do
      parsed_option = { 'id' => 1, 'rental_id' => 2, 'type' => 'gps' }
      current_rental_id = 1
      current_rental_options = []
      _(OptionValidator.validate(parsed_option, current_rental_id, current_rental_options)).must_equal false
    end
    
    it 'returns false if the option type is invalid' do
      parsed_option = { 'id' => 1, 'rental_id' => 1, 'type' => 'invalid' }
      current_rental_id = 1
      current_rental_options = []
      _(OptionValidator.validate(parsed_option, current_rental_id, current_rental_options)).must_equal false
    end

    it 'returns false if the option is already persisted for the current rental' do
      parsed_option = { 'id' => 3, 'rental_id' => 1, 'type' => 'gps' }
      current_rental_id = 1
      current_rental_options = [Option.new(1, 1, 'gps')]
      _(OptionValidator.validate(parsed_option, current_rental_id, current_rental_options)).must_equal false
    end
  end
end
