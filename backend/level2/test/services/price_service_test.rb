require_relative '../test_helper'
require_relative '../../services/price_rate_service'

describe PriceRateService do
  describe '#compute_price_per_day_rate' do
    it 'returns 100% rate for the first day' do
      _(PriceRateService.compute_price_per_day_rate(1)).must_equal 1
    end

    it 'returns 90% rate after the first day and until the end of the fourth day' do
      _(PriceRateService.compute_price_per_day_rate(2)).must_equal 0.9
      _(PriceRateService.compute_price_per_day_rate(3)).must_equal 0.9
      _(PriceRateService.compute_price_per_day_rate(4)).must_equal 0.9
    end

    it 'returns 70% rate after the fourth day and until the end of the tenth day' do
      _(PriceRateService.compute_price_per_day_rate(5)).must_equal 0.7
      _(PriceRateService.compute_price_per_day_rate(6)).must_equal 0.7
      _(PriceRateService.compute_price_per_day_rate(7)).must_equal 0.7
      _(PriceRateService.compute_price_per_day_rate(8)).must_equal 0.7
      _(PriceRateService.compute_price_per_day_rate(9)).must_equal 0.7
      _(PriceRateService.compute_price_per_day_rate(10)).must_equal 0.7
    end

    it 'returns 50% rate after the tenth day' do
      _(PriceRateService.compute_price_per_day_rate(11)).must_equal 0.5
      _(PriceRateService.compute_price_per_day_rate(12)).must_equal 0.5
      _(PriceRateService.compute_price_per_day_rate(13)).must_equal 0.5
      _(PriceRateService.compute_price_per_day_rate(14)).must_equal 0.5
      _(PriceRateService.compute_price_per_day_rate(15)).must_equal 0.5
      # ...
    end
    
  end
end