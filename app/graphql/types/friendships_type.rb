# frozen_string_literal: true

module Types
  class FriendshipsType < Types::BaseAggregation
    aggregates Types::FriendshipType
  end
end
