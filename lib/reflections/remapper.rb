module Reflections
  class Remapper
    attr_reader :from_obj, :to_obj
    def initialize(from, to)
      @from_obj = from
      @to_obj = to
    end

    def remap
      protect_remap_from_other_classes

      ActiveRecord::Base.descendants.each do |ar_class|
        belongs_to_associations_for_other_class(ar_class).each do |assoc|
          assoc.active_record.where(assoc.name => from_obj).each do |record|
            record.update_attribute assoc.name, to_obj
          end
        end
      end
    end

    private

    def belongs_to_associations_for_other_class(ar_class)
      filter = belongs_to_for_obj_class(from_obj.class)
      all_belongs_to_associations(ar_class).select &filter
    end

    def belongs_to_for_obj_class(klass)
      ->(assoc) {
        assoc.name == klass.to_s.underscore.to_sym || assoc.options[:class_name] == klass.model_name
      }
    end

    def all_belongs_to_associations(ar_class)
      ar_class.reflect_on_all_associations(:belongs_to)
    end

    def protect_remap_from_other_classes
      if from_obj.class != to_obj.class
        raise NotSameClass, "#{from_obj.class} is not the same class as #{to_obj.class}"
      end
    end

    class NotSameClass < RuntimeError; end
  end
end
