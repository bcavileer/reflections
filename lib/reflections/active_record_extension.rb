require_relative 'remapper'

module Reflections
  module ActiveRecordExtension
    extend ActiveSupport::Concern

    def map_belongs_to_associations_to(ar_obj)
      Remapper.new(self, ar_obj).remap
    end
  end
end
