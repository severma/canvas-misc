class Base    
	attr_reader :config
	attr_reader :auth_token
	attr_reader :base_url

    def initialize(config_path = nil,env_type)
		puts "initialize :#{self.class.name}"
		#puts env_type
	    if config_path
	      @config = parse_config_new(config_path)
	    else 
	      @config = {}
	    end
	    if env_type
	    	api_key_name="api_key_#{env_type}"
	    	base_url_key_name="base_url_#{env_type}"
	    else
	    	api_key_name="api_key_test"
	    	base_url_key_name="base_url_test"
	    end

	    puts @config
	   # api_key_name="api_key_#{env}"
	    puts api_key_name
	    if config[api_key_name].nil?
	    	raise ArgumentError.new("Key #{api_key_name} missing in #{config_path}")
	    end
	    if config[base_url_key_name].nil?
	    	raise ArgumentError.new("Key #{base_url_key_name} missing in #{config_path}")
	    end
	    @auth_token = "Bearer " +config[api_key_name.to_s] 
	    @base_url =config[base_url_key_name.to_s]
	    puts "base_url:#{base_url}"
  	end
  

	def parse_config_new(config_path)
		parsed = begin  
      		 YAML.load(File.open(config_path))  
    	rescue Exception => e  
    	  	puts "Could not parse config YAML: #{e.message}"  
  	  end 
   
	end   
end