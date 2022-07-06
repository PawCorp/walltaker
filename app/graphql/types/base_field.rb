module Types
  class BaseField < GraphQL::Schema::Field
    argument_class Types::BaseArgument

    def initialize(*args, requires_api_key: false, **kwargs, &block)
      @requires_api_key = requires_api_key
      super(*args, **kwargs, &block)
    end

    def authorized?(obj, args, ctx)
      user_api_key = obj&.api_key if @requires_api_key
      super && (@requires_api_key ? user_api_key === ctx[:api_key] : true)
    end
  end
end
