class PriceService
  PRICE_RATES = [
    [1, 0.9],
    [4, 0.7],
    [10, 0.5]
  ].freeze

  def self.compute_rental_price_rate(day)
    PRICE_RATES.select { |(days, rate)| days < day }.flatten.last || 1
  end

  def self.compute_distance_price(rental, car)
    rental.distance * car.price_per_km
  end

  def self.compute_rental_price(rental, car)
    duration_in_days = (rental.start_date..rental.end_date).count
    (1..duration_in_days).inject(0) do |total_price, day|
      total_price += car.price_per_day * compute_rental_price_rate(day)
      total_price.to_i
    end
  end

  def self.compute_total_price(rental, car)
    distance_price = compute_distance_price(rental, car)
    rental_price = compute_rental_price(rental, car)
    distance_price + rental_price
  end

  def self.compute_commission(rental, car)
    duration_in_days = (rental.start_date..rental.end_date).count
    total_commission = (compute_total_price(rental, car) * 0.3).to_i
    insurance_fee = (total_commission * 0.5).to_i
    assistance_fee = 100 * duration_in_days
    drivy_fee = total_commission - insurance_fee - assistance_fee

    { total_commission:, insurance_fee:, assistance_fee:, drivy_fee: }
  end
end