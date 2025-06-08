require 'date'

class DateValidator
  def self.validate(date_str)
    # Check if the date is a valid date
    Date.parse(date_str)
    # If the date is valid, return true
    true
    # If the date is not valid, return false
  rescue Date::Error
    false
  end
end