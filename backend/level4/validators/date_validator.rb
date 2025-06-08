require 'date'

class DateValidator
  def self.validate(date_str)
    Date.parse(date_str)
    true
  rescue Date::Error
    false
  end
end