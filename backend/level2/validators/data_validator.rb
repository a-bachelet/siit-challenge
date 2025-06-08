class DataValidator
  def self.validate(parsed_data)
    return false unless parsed_data.is_a?(Hash)

    mandatory_keys = ['cars', 'rentals']
    return false unless mandatory_keys.all? { |key| parsed_data.key?(key) }

    mandatory_array_values = ['cars', 'rentals']
    return false unless mandatory_array_values.all? { |key| parsed_data[key].is_a?(Array) }

    true
  end
end