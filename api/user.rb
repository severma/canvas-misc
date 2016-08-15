require 'rest_client'  
require 'json'  
require 'yaml'  
require_relative 'base' 

class User < Base
	
	def createuser (accountid, parameters)
		#puts 'createuser'
		puts parameters.to_json 
		user_url = base_url + "/api/v1/accounts/" + accountid.to_s + "/users"
		puts "API Url:#{user_url}"
      	
      	begin	
		response = RestClient.post(user_url,parameters,
									{:Authorization => auth_token.to_s ,:content_type => :json,:accept => 'application/json'})
		puts "#{response.to_str}"
   		puts "Response status: #{response.code}"
      	data_json_arr = JSON.parse response.to_s  
      	#puts data_json_arr
      	rescue => e
      		puts e.response
      	end
      	
      	return data_json_arr
	end

	def getuserlogins(userId)
		puts 'getuserlogins'
		
		# GET /api/v1/users/:user_id/logins 

		user_url = base_url + "/api/v1/users/" + userId.to_s + "/logins"
		
		puts "API Url:#{user_url}"

		response = RestClient.get user_url, :Authorization => auth_token 
      	data_json = JSON.parse response.to_s  
      	#puts data_json
      	return data_json
  end

  def updateuserlogin(accountid, userId, parameters)
  		puts 'updateuserlogin'
  		# PUT /api/v1/accounts/:account_id/logins/:id 

		puts parameters.to_json 
		user_url = base_url + "/api/v1/accounts/" + accountid.to_s + "/logins/"+ userId.to_s
		puts "API Url:#{user_url}"
      	begin	
		response = RestClient.put(user_url,parameters,
									{:Authorization => auth_token.to_s ,:content_type => :json,:accept => 'application/json'})
		puts "#{response.to_str}"
   		puts "Response status: #{response.code}"
      	data_json_arr = JSON.parse response.to_s  
      	#puts data_json_arr
      	rescue => e
      		puts e.response
      	end
      	
      	return data_json_arr
  end

end
