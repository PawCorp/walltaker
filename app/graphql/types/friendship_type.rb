# frozen_string_literal: true

module Types
  class FriendshipType < Types::BaseObject
    field :id, ID, null: false
    field :sender, Types::UserType, null: false
    field :receiver, Types::UserType
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :confirmed, Boolean

    def sender
      User.find(object.sender_id)
    end

    def receiver
      User.find(object.receiver_id)
    end
  end
end
