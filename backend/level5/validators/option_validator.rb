require_relative '../models/option'
require_relative 'date_validator'

class OptionValidator
  def self.validate(parsed_option, current_rental_id, current_rental_options)
    # Check if parsed_option is a Hash
    return false unless parsed_option.is_a?(Hash)

    # Check if all mandatory keys are present
    mandatory_keys = ['id', 'rental_id', 'type']
    return false unless mandatory_keys.all? { |key| parsed_option.key?(key) }

    # Check if all mandatory numeric values are present and positive
    mandatory_numeric_values = ['id', 'rental_id']
    return false unless mandatory_numeric_values.all? { |key| parsed_option[key].to_i.positive? }

    # Check if the option is for the current rental
    return false unless current_rental_id == parsed_option['rental_id']

    # Check if the option type is valid
    return false unless Option::TYPES.include?(parsed_option['type']&.to_sym)

    # Check if the option is already persisted for the current rental
    return false if current_rental_options.any? { |current_option| current_option.type == parsed_option['type']&.to_sym }

    # If all checks pass, return true
    true
  end
end