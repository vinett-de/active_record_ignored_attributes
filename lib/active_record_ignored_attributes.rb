require 'active_record'
require "active_record_ignored_attributes/version"
require "active_record_ignored_attributes/same_attributes_as"
require "active_record_ignored_attributes/has_attribute_values"
require "active_record_ignored_attributes/inspect"

module ActiveRecordIgnoredAttributes
  extend ActiveSupport::Concern

  included do
    # TODO: class_inheritable_accessor
    def self.ignored_attributes
      [:id, :created_at, :updated_at]
    end
  end

  def attributes_without_ignored_attributes(options = {})
    considered_attributes = if options[:only]
      options[:only]
    elsif options[:except]
      self.class.ignored_attributes - options[:except]
    else
      self.class.ignored_attributes
    end
    
    attributes.except(*considered_attributes.map(&:to_s))
  end

end

ActiveRecord::Base.class_eval do
  include ActiveRecordIgnoredAttributes
  include ActiveRecordIgnoredAttributes::SameAttributesAs
  include ActiveRecordIgnoredAttributes::HasAttributeValues
  include ActiveRecordIgnoredAttributes::Inspect
end
