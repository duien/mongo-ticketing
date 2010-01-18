# This module allows a MongoMapper document to detect changes in a
# more complex key that would generally not get marked as dirty.
#
# Author:: Emily Price (mailto:price.emily@gmail.com)

# Include this module in a class that include MongoMapper::Document
module ChangeDetection
  def self.included(model)
    model.class_eval do
      def self.detect_changes_for( assoc_or_key )
        @changes_detected_for ||= []
        @changes_detected_for.push assoc_or_key
      end

      def self.changes_detected_for
        @changes_detected_for || []
      end

      def detect_changes
        klass = self.class
        reloaded = klass.find( id )
        self.class.changes_detected_for.each do |assoc_or_key|
          if klass.keys.include? assoc_or_key
            old_value = reloaded.__send__(assoc_or_key)
            changed_keys[assoc_or_key] = old_value unless old_value == __send__(assoc_or_key)
          elsif false # if an association
            # other stuff
          end
        end
      end
    end

  end
end
