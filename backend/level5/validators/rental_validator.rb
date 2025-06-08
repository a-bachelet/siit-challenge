require_relative 'date_validator'

class RentalValidator
  def self.validate(parsed_rental, persisted_car_ids, persisted_rental_ids)
    # Check if parsed_rental is a Hash
    return false unless parsed_rental.is_a?(Hash)

    # Check if all mandatory keys are present
    mandatory_keys = ['id', 'car_id', 'start_date', 'end_date', 'distance']
    return false unless mandatory_keys.all? { |key| parsed_rental.key?(key) }

    # Check if all mandatory numeric values are present and positive
    mandatory_numeric_values = ['id', 'car_id', 'distance']
    return false unless mandatory_numeric_values.all? { |key| parsed_rental[key].to_i.positive? }

    # Check if the rental ID is already persisted
    return false if persisted_rental_ids.include?(parsed_rental['id'])

    # Check if the car ID is persisted
    return false unless persisted_car_ids.include?(parsed_rental['car_id'])

    # Check if the start and end dates are valid
    mandatory_date_values = ['start_date', 'end_date']
    return false unless mandatory_date_values.all? { |key| DateValidator.validate(parsed_rental[key]) }

    # Check if the start date is before or equal the end date
    return false unless Date.parse(parsed_rental['start_date']) <= Date.parse(parsed_rental['end_date'])

    # If all checks pass, return true
    true
  end
end