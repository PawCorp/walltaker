# frozen_string_literal: true

module Types
  class PastLinkType < Types::BaseObject
    field :id, ID, null: false
    field :user, Types::UserType
    field :post, Types::PostType, method: :itself
    field :link, Types::LinkType
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end
