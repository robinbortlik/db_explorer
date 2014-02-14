module Ransack
  class Context
    attr_reader :search, :object, :klass, :base, :engine, :arel_visitor
    attr_accessor :auth_object, :search_key

    def initialize(object, options = {})
      @object = object.all
      @klass = @object.klass
      @join_dependency = join_dependency(@object)
      @join_type = options[:join_type] || Arel::OuterJoin
      @search_key = options[:search_key] || Ransack.options[:search_key]
      @base = @join_dependency.join_base
      #changed to allow pass engine param
      @engine = options[:engine] || @base.arel_engine
      @default_table = Arel::Table.new(@base.table_name, :as => @base.aliased_table_name, :engine => @engine)
      @bind_pairs = Hash.new do |hash, key|
        parent, attr_name = get_parent_and_attribute_name(key.to_s)
        if parent && attr_name
          hash[key] = [parent, attr_name]
        end
      end
    end

  end
end