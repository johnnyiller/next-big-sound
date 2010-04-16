require 'memcache'
require 'digest/md5'
module NBS  
  module MemcachedMemoize
    def remember(name)
     
     original_method = instance_method(name)
     define_method(name) do |*args|
      
      if defined?(KEYSTORE)
       key = args.collect {|c| c.to_s }.join("_").gsub(" ","_")
       key+=name.to_s
       key = Digest::MD5.hexdigest(key)
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
     else
       bound_method = original_method.bind(self)
       bound_method.call(*args)
     end
     end
    end   
  end
end