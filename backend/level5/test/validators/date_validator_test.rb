require_relative '../test_helper'
require_relative '../../validators/date_validator'

describe DateValidator do
  describe 'self.validate' do
    it 'returns true if the date is valid' do
      _(DateValidator.validate('2021-01-01')).must_equal true
    end
  
    it 'returns false if the date is invalid' do
      _(DateValidator.validate('INVALID DATE')).must_equal false
    end
  end
end