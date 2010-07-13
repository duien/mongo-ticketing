class Symbol
  def self.to_mongo(value)
    # convert value to a mongo safe data type
    value.to_s
  end
  
  def self.from_mongo(value)
    # convert value from a mongo safe data type to your custom data type
    value.to_sym
  end
end