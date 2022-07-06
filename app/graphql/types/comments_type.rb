# frozen_string_literal: true

module Types
  class CommentsType < Types::BaseAggregation
    aggregates Types::CommentType
  end
end
