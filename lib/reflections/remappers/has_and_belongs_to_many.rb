module Reflections
  module Remappers
    class HasAndBelongsToMany < Reflections::Remapper
      REMAPPERS << 'has_and_belongs_to_many'
      attr_reader :from_obj, :to_obj

      def remap(&block)
        ActiveRecord::Base.descendants.each do |ar_class|
          associations_for_class(ar_class).each do |assoc|
            ar_class.includes(assoc.name).where("#{assoc.join_table}.#{assoc.foreign_key}").references(assoc.name).each do |record|
              update_record_or_yield record, assoc.name, &block
            end
          end
        end
      end

      private

      def filter_for_class(klass)
        ->(assoc) {
          assoc.name == klass.to_s.pluralize.underscore.to_sym || assoc.options[:class_name] == klass.model_name
        }
      end

      def update_record(record, association_name)
        association = record.send association_name
        association.delete(from_obj)
        association << to_obj
      end

      def associations(ar_class)
        ar_class.reflect_on_all_associations :has_and_belongs_to_many
      end

    end
  end
end

