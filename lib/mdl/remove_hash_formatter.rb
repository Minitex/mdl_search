module MDL
  class RemoveHashFormatter
    def self.format(values)
      values unless values.is_a?(Hash)
    end
  end
end
