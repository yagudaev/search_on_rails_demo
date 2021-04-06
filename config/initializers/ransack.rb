# Patch to remove search method see: https://github.com/activerecord-hackery/ransack#ransack-search-method
module Ransack
  module Adapters
    module ActiveRecord
      module Base
        def self.extended(base)
          base.class_eval do
            class_attribute :_ransackers
            class_attribute :_ransack_aliases
            self._ransackers ||= {}
            self._ransack_aliases ||= {}
          end
        end
      end
    end
  end
end
