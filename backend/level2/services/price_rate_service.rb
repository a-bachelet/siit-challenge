class PriceRateService
  PRICE_RATES = [
    [1, 0.9],
    [4, 0.7],
    [10, 0.5]
  ].freeze

  def self.compute_price_per_day_rate(day)
    PRICE_RATES.select { |(days, rate)| days < day }.flatten.last || 1
  end
end