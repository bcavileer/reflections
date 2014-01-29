module Reflections
  module Remappers
    class HasAndBelongsToMany < Reflections::Remapper
      REMAPPERS << 'has_and_belongs_to_many'

      def remap(ar_classes, &block)
        ar_classes.each do |ar_class|
          associations_for_class(ar_class).each do |association|
            ar_class.includes(association.name).where("#{association.join_table}.#{association.foreign_key}").references(association.name).each do |record|
              update_record_or_yield record, association, &block
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

      def update_record(record, association)
        association = record.send association.name
        association.delete(from_obj)
        association << to_obj
      end

      def associations(ar_class)
        ar_class.reflect_on_all_associations :has_and_belongs_to_many
      end

    end
  end
end

