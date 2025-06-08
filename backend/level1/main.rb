require 'json'
require_relative 'services/rental_service'

input_data = File.read('data/input.json')
output_data = { rentals: RentalService.new(input_data).compute_rentals_price }

File.write('data/output.json', JSON.pretty_generate(output_data))
