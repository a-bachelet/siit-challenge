require 'date'

class Rental
  DURATION_PRICE_RATES = { 1 => 0.9, 4 => 0.7, 10 => 0.5 }.freeze

  attr_reader :id, :car, :options, :start_date, :end_date, :distance

  def self.duration_price_rate(day)
    DURATION_PRICE_RATES.select { |(days, rate)| days < day }.flatten.last || 1
  end

  def initialize(id, car, options, start_date, end_date, distance)
    @id = id
    @car = car
    @options = options
    @start_date = Date.parse(start_date)
    @end_date = Date.parse(end_date)
    @distance = distance
  end

  def days
    (start_date..end_date).count
  end

  def duration_price
    (1..days).inject(0) do |total_price, day|
      total_price += car.price_per_day * Rental.duration_price_rate(day)
      total_price.to_i
    end
  end

  def distance_price
    distance * car.price_per_km
  end

  def options_price
    options.sum { |option| option.total_price(days) }
  end

  def total_price
    duration_price + distance_price + options_price
  end

  def total_price_without_options
    duration_price + distance_price
  end

  def commission_details
    total_commission = (total_price_without_options * 0.3).to_i
    insurance_fee = (total_commission * 0.5).to_i
    assistance_fee = 100 * days
    drivy_fee = total_commission - insurance_fee - assistance_fee

    { total_commission:, insurance_fee:, assistance_fee:, drivy_fee: }
  end

  def option(type)
    options.find { |option| option.type == type }
  end

  def options_amount_for(actor)
    options.select { |option| option.goes_to?(actor) }.sum { |option| option.total_price(days) }
  end
end
