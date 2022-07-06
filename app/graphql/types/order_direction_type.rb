# frozen_string_literal: true

module Types
  class OrderDirectionType < Types::BaseEnum
    description "Order direction enum for use when using Aggregation order input"
    value "asc", "Ascending"
    value "desc", "Descending"
  end
end
