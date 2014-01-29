module Reflections
  module Remappers
    class BelongsTo < Reflections::Remapper
      REMAPPERS << 'belongs_to'

      def remap(&block)
        ActiveRecord::Base.descendants.each do |ar_class|
          associations_for_class(ar_class).each do |association|
            foreign_key = association.foreign_key || "#{association.name}_id"
            ar_class.where(foreign_key => from_obj).each do |record|
              update_record_or_yield record, association, &block
            end
          end
        end
      end

      private

      def filter_for_class(klass)
        ->(assoc) {
          assoc.name == klass.to_s.underscore.to_sym || assoc.options[:class_name] == klass.model_name
        }
      end

      def update_record(record, association)
        record.update_attribute association.name, to_obj
      end

      def associations(ar_class)
        ar_class.reflect_on_all_associations :belongs_to
      end

    end
  end
end



