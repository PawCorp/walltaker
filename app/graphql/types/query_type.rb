module Types
  class QueryType < Types::BaseObject
    # Add `node(id: ID!) and `nodes(ids: [ID!]!)`
    include GraphQL::Types::Relay::HasNodeField
    include GraphQL::Types::Relay::HasNodesField

    field :link, Types::LinkType,
          description: "Get a link by it's publicly accessible feed ID" do
      argument :id, Int
    end

    field :user, Types::UserType,
          description: "Get a user by their username" do
      argument :username, String
    end

    field :me, Types::UserType,
          description: "Get the user object for the current api_key header"

    def link(id:)
      Link.find(id)
    end

    def user(username:)
      User.find_by(username:)
    end

    def me
      User.find_by(api_key: context[:api_key])
    end
  end
end
