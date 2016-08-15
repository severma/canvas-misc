require 'rest_client'  
require 'json'  
require 'yaml' 
require_relative 'base'  

class Account < Base
	
	def getrootaccount 
		puts 'getrootaccount'
		
      	account_url = base_url + "/api/v1/accounts"
      	response = RestClient.get account_url, :Authorization => auth_token.to_s 
      	data_json_arr = JSON.parse response.to_s  
      #	puts data_json_arr
      	return data_json_arr
	end

	def getrootaccount_refactored 
		puts 'getrootaccount_refactored'

		per_page = config["per_page"].to_s
      	app_url = base_url + "/api/v1/accounts?per_page=" + per_page
		data_collected = 0  
       	#the array of JSON objects returned from the Courses API calls  
  	  	data_json_arr = []  
  		num_call = 0
		exists = true
	    while exists
	    	num_call += 1
	    	puts app_url
	        response = RestClient.get app_url, :Authorization => auth_token  
	        puts response
	        links = response.headers[:link]  
	        all_links = links.split(",")  
	       # puts all_links
	        #the next link is the 1st in the Links header if there are more pages in the pagination structure, and the actual URL is inside the  
	        #first in the chunk that's returned. It should look like this:  
	        #Link: <https://<canvas-instance>/api/v1/accounts/:id/courses?page=2&per_page=50>; rel="next"  
	        #next_link = all_links[0].split(';')[0].gsub(/\<|\>/, "")  
	        next_link =""
	        all_links.each do |link|
	           # puts 's:'+link
	            val = link.split(";")[1].gsub(/"/, "")  
	           # puts val
	           
	            if val.include? "next"
	                next_link= link.split(';')[0].gsub(/\<|\>/, "")  
	                #puts 'seema:'+link
	                break
	            end  
	        end

	        #puts next_link  
	        app_url = next_link  
	        temp_arr = JSON.parse response.to_s  
	        #puts temp_arr.length
	        if (next_link.length <=0 )
	            exists = false
	        end
	        #puts exists
	        data_json_arr.concat temp_arr  
	        data_collected += temp_arr.length  
	        #puts "Total Number of Account IDs Collected: " + data_collected.to_s  
	    end 
	    puts "Total number of API call: #{num_call.to_s}"
      	return data_json_arr
	end

	def getsubaccount subaccountid
		puts 'getsubaccount'
		
		per_page = config["per_page"].to_s
    	#subaccountid = config["subaccount_id"].to_s	
		#base_url =config["base_url"]

      	subaccount_url = base_url + "/api/v1/accounts/" + subaccountid.to_s + "/sub_accounts?page=1&per_page=" + per_page+"&recursive=true"
      	
    	data_collected = 0  
       	#the array of JSON objects returned from the Courses API calls  
  	  	data_json_arr = []  
  
		exists = true
	    while exists
	        response = RestClient.get subaccount_url, :Authorization => auth_token  
	        links = response.headers[:link]  
	        all_links = links.split(",")  
	       # puts all_links
	        #the next link is the 1st in the Links header if there are more pages in the pagination structure, and the actual URL is inside the  
	        #first in the chunk that's returned. It should look like this:  
	        #Link: <https://<canvas-instance>/api/v1/accounts/:id/courses?page=2&per_page=50>; rel="next"  
	        #next_link = all_links[0].split(';')[0].gsub(/\<|\>/, "")  
	        next_link =""
	        all_links.each do |link|
	           # puts 's:'+link
	            val = link.split(";")[1].gsub(/"/, "")  
	           # puts val
	           
	            if val.include? "next"
	                next_link= link.split(';')[0].gsub(/\<|\>/, "")  
	                #puts 'seema:'+link
	                break
	            end  
	        end

	        #puts next_link  
	        subaccount_url = next_link  
	        temp_arr = JSON.parse response.to_s  
	        #puts temp_arr.length
	        if (next_link.length <=0 )
	            exists = false
	        end
	        #puts exists
	        data_json_arr.concat temp_arr  
	        data_collected += temp_arr.length  
	        #puts "Total Number of Account IDs Collected: " + data_collected.to_s  
	    end 
	    return data_json_arr
	end	

	def adminbyAccount subaccount
		#puts 'adminbyAccount'
		# /api/v1/accounts/:account_id/admins 
	
    	api_url = base_url + "/api/v1/accounts/" + subaccount.to_s + "/admins?per_page=1000"
      
      	response = RestClient.get api_url, :Authorization => auth_token 
      	data_json_arr = JSON.parse response.to_s  
      	#puts data_json_arr
      	return data_json_arr

	end


	def getsingleaccount accountid
		puts 'getsingleaccount'
		
      	account_url = base_url + "/api/v1/accounts/"+accountid.to_s

      	puts account_url
      	response = RestClient.get account_url, :Authorization => auth_token 
      	data_json = JSON.parse response.to_s  
      	#puts data_json_arr
      	return data_json
	end

end
