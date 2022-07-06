# frozen_string_literal: true

module Types
  class PastLinksType < Types::BaseAggregation
    aggregates Types::PastLinkType
  end
end
