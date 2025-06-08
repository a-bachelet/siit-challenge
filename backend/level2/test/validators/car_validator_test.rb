require_relative '../test_helper'
require_relative '../../validators/car_validator'

describe CarValidator do
  before do
    @valid_car = { "id" => 1, "price_per_day" => 100, "price_per_km" => 10 }
    @invalid_cars = [
      { "price_per_day" => 50, "price_per_km" => 10 },
      { "id" => 1, "price_per_km" => 10 },
      { "id" => 1, "price_per_day" => 50,},
      { "id" => 0, "price_per_day" => 50, "price_per_km" => 10 },
      { "id" => 1, "price_per_day" => 50, "price_per_km" => 0 }
    ]
  end

  describe 'self.validate' do
    it 'validates valid car' do
      _(CarValidator.validate(@valid_car, [])).must_equal true
    end

    it 'does not validate invalid car' do
      @invalid_cars.each do |invalid_car|
        _(CarValidator.validate(invalid_car, [])).must_equal false
      end
    end

    it 'does not validate car with id already registered' do
      _(CarValidator.validate(@valid_car, [@valid_car['id']])).must_equal false
    end
  end
end