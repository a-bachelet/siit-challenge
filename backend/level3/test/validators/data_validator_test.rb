require_relative '../test_helper'
require_relative '../../validators/data_validator'

describe DataValidator do
  before do
    @valid_data = { "cars" => [], "rentals" => [] }

    @invalid_data = [
      { "cars" => [] },
      { "rentals" => [] },
      { "cars" => "CAR 1, CAR 2", "rentals" => [] },
      { "cars" => [], "rentals" => "RENTAL 1, RENTAL 2" }
    ]
  end

  describe 'self.validate' do
    it 'validates valid data' do
      _(DataValidator.validate(@valid_data)).must_equal true
    end

    it 'does not validate invalid data' do
      @invalid_data.each do |invalid_data|
        _(DataValidator.validate(invalid_data)).must_equal false
      end
    end
  end
end