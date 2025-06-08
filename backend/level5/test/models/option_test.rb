require_relative '../test_helper'
require_relative '../../models/option'
require_relative '../../models/payment'

describe Option do
  describe 'initialize' do
    it 'returns a Option object' do
      option = Option.new(1, 1, 'gps')
      _(option).must_be_instance_of Option
    end

    it 'assigns parameters to instance variables' do
      option = Option.new(1, 1, 'gps')
      _(option.id).must_equal 1
      _(option.rental_id).must_equal 1
      _(option.type).must_equal Option::Type::GPS
    end
  end

  describe 'price_per_day' do
    it 'returns the price per day for the option' do
      [
        [Option::Type::GPS.to_s, Option::PRICE_PER_DAY[Option::Type::GPS]],
        [Option::Type::BABY_SEAT.to_s, Option::PRICE_PER_DAY[Option::Type::BABY_SEAT]],
        [Option::Type::ADDITIONAL_INSURANCE.to_s, Option::PRICE_PER_DAY[Option::Type::ADDITIONAL_INSURANCE]]
      ].each do |type, price|
        option = Option.new(1, 1, type)
        _(option.price_per_day).must_equal price
      end
    end
  end

  describe 'total_price' do
    it 'returns the total price for the option' do
      [
        [Option::Type::GPS.to_s, 3, Option::PRICE_PER_DAY[Option::Type::GPS] * 3],
        [Option::Type::BABY_SEAT.to_s, 9, Option::PRICE_PER_DAY[Option::Type::BABY_SEAT] * 9],
        [Option::Type::ADDITIONAL_INSURANCE.to_s, 43, Option::PRICE_PER_DAY[Option::Type::ADDITIONAL_INSURANCE] * 43]
      ].each do |type, days, price|
        option = Option.new(1, 1, type)
        _(option.total_price(days)).must_equal price
      end
    end
  end

  describe 'goes_to' do
    it 'returns the actor for the option' do
      [
        [Option::Type::GPS.to_s, Payment::Actor::OWNER],
        [Option::Type::BABY_SEAT.to_s, Payment::Actor::OWNER],
        [Option::Type::ADDITIONAL_INSURANCE.to_s, Payment::Actor::DRIVY]
      ].each do |type, actor|
        option = Option.new(1, 1, type)
        _(option.goes_to).must_equal actor
      end
    end
  end

  describe 'goes_to?' do
    it 'returns true if the option goes to the actor' do
      [
        [Option::Type::GPS.to_s, Payment::Actor::OWNER, true],
        [Option::Type::GPS.to_s, Payment::Actor::DRIVY,   false],
        [Option::Type::BABY_SEAT.to_s, Payment::Actor::OWNER, true],
        [Option::Type::BABY_SEAT.to_s, Payment::Actor::DRIVY, false],
        [Option::Type::ADDITIONAL_INSURANCE.to_s, Payment::Actor::DRIVY, true],
        [Option::Type::ADDITIONAL_INSURANCE.to_s, Payment::Actor::OWNER, false]
      ].each do |type, actor, result|
        option = Option.new(1, 1, type)
        _(option.goes_to?(actor)).must_equal result
      end
    end
  end


end