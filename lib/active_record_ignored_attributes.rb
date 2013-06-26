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
    attributes.except(*excepted_attributes(options).map(&:to_s))
  end

  private

  def excepted_attributes(options = {})
    if options[:only]
      attributes.keys - options[:only]
    elsif options[:ignore]
      self.class.ignored_attributes.concat(options[:ignore])
    else
      self.class.ignored_attributes
    end
  end
end

ActiveRecord::Base.class_eval do
  include ActiveRecordIgnoredAttributes
  include ActiveRecordIgnoredAttributes::SameAttributesAs
  include ActiveRecordIgnoredAttributes::HasAttributeValues
  include ActiveRecordIgnoredAttributes::Inspect
end
