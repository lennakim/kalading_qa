module Concerns
  module AutoSync
    extend ActiveSupport::Concern

    module ClassMethods
      def attr_sync(*attrs)
        @sync_attributes = attrs
      end

      def extract_sync_attributes(attrs)
        attrs.slice( *@sync_attributes.map(&:to_s) )
      end

      def sync(internal_id, attrs)
        model = where(internal_id: internal_id).first || new(internal_id: internal_id)
        model.update_attributes(extract_sync_attributes(attrs))
        model
      end
    end
  end
end
