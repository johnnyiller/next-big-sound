module NBS
  class DataPoint
  
    attr_accessor :time, :value
    
    def initialize(time,value)
      self.time = DateTime.parse(time.to_s)
      self.value = value.to_f
    end
    
  end
end