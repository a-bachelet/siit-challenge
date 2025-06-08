require_relative '../test_helper'
require_relative '../../services/rental_service'

describe RentalService do
  describe '#initialize' do
    before do
      @valid_fixture_file_path = File.join(__dir__, '..', 'fixtures', 'files', 'valid_input.json')
    end

    describe 'when data validation is not successful' do
      it 'raises an error' do
        DataValidator.stub :validate, false do
          _(-> { RentalService.new(File.read(@valid_fixture_file_path)) }).must_raise 'Invalid JSON data'
        end
      end
    end

    describe 'when data validation is successful' do
      before do
        @rental_service = RentalService.new(File.read(@valid_fixture_file_path))
      end

      it 'creates a new rental service' do
        _(@rental_service).must_be_instance_of RentalService
      end

      it 'imports cars' do
        _(@rental_service.cars).must_be_instance_of Array
        _(@rental_service.cars.length).must_equal 3
      end

      it 'imports rentals' do
        _(@rental_service.rentals).must_be_instance_of Array
        _(@rental_service.rentals.length).must_equal 3
      end
    end

    describe 'when data validation is successful but data is invalid' do
      before do
        @invalid_fixture_file_path = File.join(__dir__, '..', 'fixtures', 'files', 'invalid_input.json')
        @rental_service = RentalService.new(File.read(@invalid_fixture_file_path))
      end

      it 'only imports valid cars' do
        _(@rental_service.cars.length).must_equal 2
        _(@rental_service.cars.map(&:id)).must_equal [2, 3]
      end

      it 'only imports valid rentals' do
        _(@rental_service.rentals.length).must_equal 1
        _(@rental_service.rentals.map(&:id)).must_equal [2]
      end
    end
  end

  describe '#compute_rentals_price' do
    before do
      @valid_fixture_file_path = File.join(__dir__, '..', 'fixtures', 'files', 'valid_input.json')
      @rental_service = RentalService.new(File.read(@valid_fixture_file_path))
    end

    it 'computes the price of all rentals' do
      _(@rental_service.compute_rentals_price).must_be_instance_of Array
      _(@rental_service.compute_rentals_price.all?  { _1.key?(:id) && _1.key?(:price) }).must_equal true
      _(@rental_service.compute_rentals_price.map { [_1[:id], _1[:price]] }).must_equal [[1, 7000], [2, 15500], [3, 11250]]
    end
  end
end