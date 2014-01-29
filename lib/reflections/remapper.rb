require 'pry'
module Reflections
  class Remapper
    REMAPPERS = []
    attr_reader :from_obj, :to_obj

    def initialize(from, to)
      @from_obj = from
      @to_obj = to
    end

    def remap(options={}, &block)
      protect_remap_from_other_classes
      @only_these_classes = options.fetch(:only) { ActiveRecord::Base.descendants }
      @except_these_classes = options.fetch(:except) { [] }
      remap_these = options.fetch(:types) { REMAPPERS }
      remap_these.each do |remapper|
        remapper_class = "Reflections::Remappers::#{remapper.to_s.camelize}".constantize
        remapper_class.new(from_obj, to_obj).remap(ar_classes, &block)
      end
    end

    protected

    def ar_classes
      @only_these_classes - @except_these_classes
    end

    private

    def protect_remap_from_other_classes
      if from_obj.class != to_obj.class
        raise NotSameClass, "#{from_obj.class} is not the same class as #{to_obj.class}"
      end
    end

    def update_record_or_yield(record, association)
      if !block_given? || block_given? && yield(record, from_obj, to_obj)
        update_record record, association
      end
    end

    def associations_for_class(ar_class)
      filter = filter_for_class from_obj.class
      associations(ar_class).select &filter
    end

    class NotSameClass < RuntimeError; end
  end
end
