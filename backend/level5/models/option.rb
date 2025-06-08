class Option
  module Type
    GPS = :gps.freeze
    BABY_SEAT = :baby_seat.freeze
    ADDITIONAL_INSURANCE = :additional_insurance.freeze
  end

  TYPES = [Type::GPS, Type::BABY_SEAT, Type::ADDITIONAL_INSURANCE].freeze

  PRICE_PER_DAY = {
    Type::GPS => 500,
    Type::BABY_SEAT => 200,
    Type::ADDITIONAL_INSURANCE => 1000
  }.freeze

  attr_reader :id, :rental_id, :type

  def initialize(id, rental_id, type)
    @id = id
    @rental_id = rental_id
    @type = type.to_sym
  end

  def price_per_day
    PRICE_PER_DAY[type]
  end

  def total_price(days)
    price_per_day * days
  end

  def goes_to
    case type
    when Type::GPS
      Payment::Actor::OWNER
    when Type::BABY_SEAT
      Payment::Actor::OWNER
    when Type::ADDITIONAL_INSURANCE
      Payment::Actor::DRIVY
    end
  end

  def goes_to?(actor)
    goes_to == actor
  end
end