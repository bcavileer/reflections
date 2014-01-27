require 'pry'
module Reflections
  class Remapper
    REMAPPERS = %w(belongs_to has_and_belongs_to_many)
    attr_reader :from_obj, :to_obj

    def initialize(from, to)
      @from_obj = from
      @to_obj = to
    end

    def remap(options={}, &block)
      protect_remap_from_other_classes
      remap_these = options.fetch(:only) { REMAPPERS }
      remap_these.each do |remapper|
        "Reflections::Remappers::#{remapper.camelize}".constantize.new(from_obj, to_obj).remap &block
      end
    end

    private

    def protect_remap_from_other_classes
      if from_obj.class != to_obj.class
        raise NotSameClass, "#{from_obj.class} is not the same class as #{to_obj.class}"
      end
    end

    def update_record_or_yield(record, association_name)
      if !block_given? || block_given? && yield(record, from_obj, to_obj)
        update_record(record, association_name)
      end
    end

    def associations_for_class(ar_class)
      filter = for_obj_class(from_obj.class)
      associations(ar_class).select &filter
    end

    class NotSameClass < RuntimeError; end
  end

  module Remappers
    class BelongsTo < Reflections::Remapper
      attr_reader :from_obj, :to_obj

      def remap &block
        ActiveRecord::Base.descendants.each do |ar_class|
          associations_for_class(ar_class).each do |assoc|
            assoc.active_record.where(assoc.name => from_obj).each do |record|
              update_record_or_yield(record, assoc.name, &block)
            end
          end
        end
      end

      private

      def for_obj_class(klass)
        ->(assoc) {
          assoc.name == klass.to_s.underscore.to_sym || assoc.options[:class_name] == klass.model_name
        }
      end

      def update_record(record, association_name)
        record.update_attribute association_name, to_obj
      end

      def associations(ar_class)
        ar_class.reflect_on_all_associations :belongs_to
      end

    end

    class HasAndBelongsToMany < Reflections::Remapper
      attr_reader :from_obj, :to_obj

      def remap &block
        ActiveRecord::Base.descendants.each do |ar_class|
          associations_for_class(ar_class).each do |assoc|
            assoc.active_record.all.each do |record|
              update_record_or_yield(record, assoc.name, &block)
            end
          end
        end
      end

      private

      def for_obj_class(klass)
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
