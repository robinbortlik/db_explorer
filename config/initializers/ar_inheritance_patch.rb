require 'active_support/concern'

module ActiveRecord
  module Inheritance
    module ClassMethods
      
      private

        def find_sti_class(type_name)
          self
          
          #if type_name.blank? || !columns_hash.include?(inheritance_column)
          #  self
          #else
          #  begin
          #    if store_full_sti_class
          #      ActiveSupport::Dependencies.constantize(type_name)
          #    else
          #      compute_type(type_name)
          #    end
          #  rescue NameError
          #    raise SubclassNotFound,
          #      "The single-table inheritance mechanism failed to locate the subclass: '#{type_name}'. " +
          #      "This error is raised because the column '#{inheritance_column}' is reserved for storing the class in case of inheritance. " +
          #      "Please rename this column if you didn't intend it to be used for storing the inheritance class " +
          #      "or overwrite #{name}.inheritance_column to use another column for that information."
          # end
          #end
        end
      
    end  
  end    
end