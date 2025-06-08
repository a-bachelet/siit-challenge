class DataValidator
  def self.validate(parsed_data)
    # Check if parsed_data is a Hash
    return false unless parsed_data.is_a?(Hash)

    # Check if all mandatory keys are present
    mandatory_keys = ['cars', 'rentals', 'options']
    return false unless mandatory_keys.all? { |key| parsed_data.key?(key) }

    # Check if all mandatory array values are present
    mandatory_array_values = ['cars', 'rentals', 'options']
    return false unless mandatory_array_values.all? { |key| parsed_data[key].is_a?(Array) }

    # If all checks pass, return true
    true
  end
end