# frozen_string_literal: true

module Types
  class UserType < Types::BaseObject
    field :id, ID, null: false
    field :username, String
    field :details, String
    field :admin, Boolean
    field :set_count, Integer, null: false
    field :links, Types::LinksType
    field :friendships, Types::FriendshipsType, requires_api_key: true
    field :past_links, Types::PastLinksType
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    def links
      Link.where(user_id: object.id)
    end

    def friendships
      object.friendships
    end

    def past_links
      PastLink.where(user_id: object.id)
    end
  end
end
