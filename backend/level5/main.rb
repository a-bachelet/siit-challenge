require 'json'
require_relative 'services/rental_service'

puts '🚀 Running RentalService...'

input_data = File.read('data/input.json')
output_data = { rentals: RentalService.new(input_data).compute_rentals_options_and_actions }

File.write('data/output.json', JSON.pretty_generate(output_data))

puts '✅ Data written to data/output.json'

output_is_expected = File.read('data/output.json') == File.read('data/expected_output.json')

puts '✅ output.json and expected_output.json are the same' if output_is_expected
puts '❌ output.json and expected_output.json are not the same' unless output_is_expected
