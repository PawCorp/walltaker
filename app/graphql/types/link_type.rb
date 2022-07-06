# frozen_string_literal: true

module Types
  class LinkType < Types::BaseObject
    field :id, Integer
    field :user, Types::UserType
    field :expires, GraphQL::Types::ISO8601DateTime
    field :never_expires, Boolean
    field :terms, String
    field :friends_only, Boolean
    field :theme, String
    field :blacklist, String
    field :post, Types::PostType, method: :itself
    field :comments, Types::CommentsType
    field :response_text, String
    field :response_type, Integer
    field :online, Boolean
    field :last_ping, GraphQL::Types::ISO8601DateTime
    field :last_ping_user_agent, String
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end
