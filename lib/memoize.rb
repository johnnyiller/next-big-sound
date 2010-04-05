require 'memcache'
module NBS  
  module MemcachedMemoize
    #KEYSTORE 
    def remember(name)
     #puts name
     original_method = instance_method(name)
     define_method(name) do |*args|
       key = args.collect {|c| c.to_s }.join("_").gsub(" ","_")
       key+=name.to_s
       puts key
       if KEYSTORE.get(key)!=nil
         puts "it was memorized" 
         Marshal.restore(KEYSTORE.get(key))
       else
         puts "it had to be memorized"  
         bound_method = original_method.bind(self)
         #puts Marshal.dump(bound_method.call(*args))
         KEYSTORE.set(key,Marshal.dump(bound_method.call(*args)))
         return Marshal.restore(KEYSTORE.get(key))
       end
     end
    end   
  end
end