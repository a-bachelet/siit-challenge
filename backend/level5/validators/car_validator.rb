class CarValidator
  def self.validate(parsed_car, persisted_car_ids)
    # Check if parsed_car is a Hash
    return false unless parsed_car.is_a?(Hash)

    # Check if all mandatory keys are present
    mandatory_keys = ['id', 'price_per_day', 'price_per_km']
    return false unless mandatory_keys.all? { |key| parsed_car.key?(key) }
    
    # Check if all mandatory numeric values are present and positive
    mandatory_numeric_values = ['id', 'price_per_day', 'price_per_km']
    return false unless mandatory_numeric_values.all? { |key| parsed_car[key].to_i.positive? }

    # Check if the car ID is already persisted
    return false if persisted_car_ids.include?(parsed_car['id'])

    # If all checks pass, return true
    true
  end
end