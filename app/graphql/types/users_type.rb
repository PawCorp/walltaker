# frozen_string_literal: true

module Types
  class UsersType < Types::BaseAggregation
    aggregates Types::UserType
  end
end
