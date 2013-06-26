module ActiveRecordIgnoredAttributes::SameAttributesAs
  def same_attributes_as?(other, options = {})
    self. attributes_without_ignored_attributes(options) ==
    other.attributes_without_ignored_attributes(options)
  end
  alias_method :same_as?, :same_attributes_as?
end
