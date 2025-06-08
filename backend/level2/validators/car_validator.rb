class CarValidator
  def self.validate(parsed_car, car_ids)
    return false unless parsed_car.is_a?(Hash)

    mandatory_keys = ['id', 'price_per_day', 'price_per_km']
    return false unless mandatory_keys.all? { |key| parsed_car.key?(key) }

    mandatory_numeric_values = ['id', 'price_per_day', 'price_per_km']
    return false unless mandatory_numeric_values.all? { |key| parsed_car[key].to_i.positive? }
    return false if car_ids.include?(parsed_car['id'])

    true
  end
end