require_relative 'reflections/version'
require_relative 'reflections/active_record_extension'

module Reflections
  ActiveRecord::Base.send(:include, ActiveRecordExtension)
end
