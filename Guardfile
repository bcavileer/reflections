# More info at https://github.com/guard/guard#readme

guard :rspec do
  watch('spec/spec_helper.rb')              { "spec" }
  watch(%r{^spec/.+_spec\.rb$})             { "spec" }
  watch(%r{^lib/reflections.rb$})           { "spec" }
  watch(%r{^lib/reflections/(.+)\.rb$})     { |m| "spec/#{m[1]}_spec.rb" }
end

