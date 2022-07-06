# frozen_string_literal: true

module Types
  class PostType < Types::BaseObject
    field :url, String, method: :post_url
    field :thumbnail_url, String, method: :post_thumbnail_url
    field :set_by, Types::UserType

    def set_by
      User.find(object.set_by_id)
    end
  end
end
