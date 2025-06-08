require_relative '../test_helper'
require_relative '../../validators/rental_validator'

describe RentalValidator do
  before do
    @valid_rental = { "id" => 1, "car_id" => 1, "start_date" => "2021-01-01", "end_date" => "2021-01-02", "distance" => 100 }
    @invalid_rentals = [
      { "car_id" => 1, "start_date" => "2021-01-01", "end_date" => "2021-01-02", "distance" => 100 },
      { "id" => 1, "start_date" => "2021-01-01", "end_date" => "2021-01-02", "distance" => 100 },
      { "id" => 1, "car_id" => 1, "end_date" => "2021-01-02", "distance" => 100 },
      { "id" => 1, "car_id" => 1, "start_date" => "2021-01-01", "distance" => 100 },
      { "id" => 1, "car_id" => 1, "start_date" => "2021-01-01" },
      { "id" => 0, "car_id" => 1, "start_date" => "2021-01-01", "end_date" => "2021-01-02", "distance" => 100 },
      { "id" => 1, "car_id" => 0, "start_date" => "2021-01-01", "end_date" => "2021-01-02", "distance" => 100 },
      { "id" => 1, "car_id" => 1, "start_date" => "INVALID DATE", "end_date" => "2021-01-02", "distance" => 100 },
      { "id" => 1, "car_id" => 1, "start_date" => "2021-01-01", "end_date" => "INVALID DATE", "distance" => 100 },
      { "id" => 1, "car_id" => 1, "start_date" => "2021-01-01", "end_date" => "2021-01-02", "distance" => -100 }
    ]
  end

  describe 'self.validate' do
    it 'validates valid rental' do
      _(RentalValidator.validate(@valid_rental, [@valid_rental['car_id']], [])).must_equal true
    end

    it 'does not validate invalid rental' do
      @invalid_rentals.each do |invalid_rental|
        _(RentalValidator.validate(invalid_rental, [], [])).must_equal false
      end
    end

    it 'does not validate rental with id already registered' do
      _(RentalValidator.validate(@valid_rental, [], [@valid_rental['id']])).must_equal false
    end

    it 'does not validate rental with car_id not registered' do
      _(RentalValidator.validate(@valid_rental, [], [])).must_equal false
    end
  end
end