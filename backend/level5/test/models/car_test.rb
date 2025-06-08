require_relative '../test_helper'
require_relative '../../models/car'

describe Car do
  describe 'initialize' do
    it 'returns a Car object' do
      car = Car.new(1, 100, 10)
      _(car).must_be_instance_of Car
    end

    it 'assigns parameters to instance variables' do
      car = Car.new(1, 100, 10)
      _(car.id).must_equal 1
      _(car.price_per_day).must_equal 100
      _(car.price_per_km).must_equal 10
    end
  end
end