module Types
  class BaseAggregation < Types::BaseObject
    implements Types::AggregationType

    def self.aggregates(type)
      field :data, [type] do
        argument :take, Integer, default_value: 20, prepare: ->(take, ctx) { [take, 100].min }
        argument :offset, Integer, default_value: 0
        argument :order_by, String, required: false
        argument :order_dir, Types::OrderDirectionType, default_value: "asc"
      end

      def data(take:, offset:, order_by: nil, order_dir:)
        return object.order(order_by => order_dir).limit(take).offset(offset) if order_by
        object.limit(take).offset(offset) unless order_by
      end
    end
  end
end
