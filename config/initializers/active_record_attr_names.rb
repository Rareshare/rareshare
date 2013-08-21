# This attempts to fix the AttrNames module redefinition bug. Apparently this is
# caused by rails-observers and fixed in future versions of Rails.
# https://github.com/rails/rails/issues/10507
module ActiveRecord
  module Core
    module ClassMethods
      def initialize_generated_modules
        @attribute_methods_mutex = Mutex.new

        unless generated_attribute_methods.constants.include?(:AttrNames)
          # force attribute methods to be higher in inheritance hierarchy than other generated methods
          generated_attribute_methods.const_set(:AttrNames, Module.new {
            def self.const_missing(name)
              const_set(name, [name.to_s.sub(/ATTR_/, '')].pack('h*').freeze)
            end
          })
        end

        generated_feature_methods
      end
    end
  end
end
