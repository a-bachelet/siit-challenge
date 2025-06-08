require_relative 'date_validator'

class RentalValidator
  def self.validate(parsed_rental, car_ids, rental_ids)
    return false unless parsed_rental.is_a?(Hash)

    mandatory_keys = ['id', 'car_id', 'start_date', 'end_date', 'distance']
    return false unless mandatory_keys.all? { |key| parsed_rental.key?(key) }

    mandatory_numeric_values = ['id', 'car_id', 'distance']
    return false unless mandatory_numeric_values.all? { |key| parsed_rental[key].to_i.positive? }
    return false if rental_ids.include?(parsed_rental['id']) || !car_ids.include?(parsed_rental['car_id'])

    mandatory_date_values = ['start_date', 'end_date']
    return false unless mandatory_date_values.all? { |key| DateValidator.validate(parsed_rental[key]) }

    true
  end
end