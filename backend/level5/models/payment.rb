class Payment
  module Actor
    DRIVER = :driver.freeze
    OWNER = :owner.freeze
    INSURANCE = :insurance.freeze
    ASSISTANCE = :assistance.freeze
    DRIVY = :drivy.freeze
  end

  module Action
    DEBIT = :debit.freeze
    CREDIT = :credit.freeze
  end

  ACTORS = [Actor::DRIVER, Actor::OWNER, Actor::INSURANCE, Actor::ASSISTANCE, Actor::DRIVY].freeze
  ACTIONS = [Action::DEBIT, Action::CREDIT].freeze

  attr_reader :actor, :action, :amount

  def initialize(actor, action, amount)
    @actor = actor.to_sym
    @action = action.to_sym
    @amount = amount
  end

  def to_h
    {
      who: actor,
      type: action,
      amount: amount
    }
  end
end