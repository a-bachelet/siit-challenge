class PriceService
  PRICE_RATES = [
    [1, 0.9],
    [4, 0.7],
    [10, 0.5]
  ].freeze

  def self.compute_rental_price_rate(day)
    PRICE_RATES.select { |(days, rate)| days < day }.flatten.last || 1
  end

  def self.compute_distance_price(distance, price_per_km)
    distance * price_per_km
  end

  def self.compute_rental_price(start_date, end_date, price_per_day)
    duration_in_days = (start_date..end_date).count
    (1..duration_in_days).inject(0) do |total_price, day|
      total_price += price_per_day * compute_rental_price_rate(day)
      total_price
    end
  end

  def self.compute_total_price(start_date, end_date, price_per_day, distance, price_per_km)
    distance_price = compute_distance_price(distance, price_per_km)
    rental_price = compute_rental_price(start_date, end_date, price_per_day)
    distance_price + rental_price
  end

  def self.compute_commission(total_price, start_date, end_date)
    duration_in_days = (start_date..end_date).count
    commission = (total_price * 0.3).to_i
    insurance_fee = (commission * 0.5).to_i
    assistance_fee = 100 * duration_in_days
    drivy_fee = commission - insurance_fee - assistance_fee

    { insurance_fee:, assistance_fee:, drivy_fee: }
  end
end