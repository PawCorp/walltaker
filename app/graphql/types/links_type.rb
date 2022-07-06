# frozen_string_literal: true

module Types
  class LinksType < Types::BaseAggregation
    aggregates Types::LinkType
  end
end
