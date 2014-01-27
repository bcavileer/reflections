require_relative 'remapper'

module Reflections
  module ActiveRecordExtension
    extend ActiveSupport::Concern

    def map_associations_to(ar_obj, options={}, &block)
      Remapper.new(self, ar_obj).remap(options, &block)
    end
  end

  ActiveRecord::Base.send(:include, ActiveRecordExtension)
end
