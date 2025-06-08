require_relative '../test_helper'
require_relative '../../validators/date_validator'

describe DateValidator do
  before do
    @valid_date = '2021-01-01'
    @invalid_date = 'INVALID DATE'
  end

  describe 'self.validate' do
    it 'validates valid date' do
      _(DateValidator.validate(@valid_date)).must_equal true
    end
  
    it 'does not validate invalid date' do
      _(DateValidator.validate(@invalid_date)).must_equal false
    end
  end
end