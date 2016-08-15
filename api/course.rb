require 'rest_client'  
require 'json'  
require 'yaml'  
require_relative 'base'  

class Course < Base
	
	def getcourses (accountid, enrollment_term_id)
		#puts 'getcourses'
		
		per_page = config["per_page"].to_s
    	
      	app_url = base_url + "/api/v1/accounts/"+accountid.to_s+"/courses?enrollment_term_id="+enrollment_term_id.to_s+"&with_enrollments=true"

    	data_collected = 0  
       	#the array of JSON objects returned from the Courses API calls  
  	  	data_json_arr = []  
  
		exists = true
	    while exists
	        response = RestClient.get app_url, :Authorization => auth_token  
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
	    return data_json_arr
	end	


	def getcourses_all (accountid, enrollment_term_id)
		#puts 'getcourses'
		
		per_page = config["per_page"].to_s
    	
      	app_url = base_url + "/api/v1/accounts/"+accountid.to_s+"/courses?enrollment_term_id="+enrollment_term_id.to_s

    	data_collected = 0  
       	#the array of JSON objects returned from the Courses API calls  
  	  	data_json_arr = []  
  
		exists = true
	    while exists
	        response = RestClient.get app_url, :Authorization => auth_token  
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
	    return data_json_arr
	end	
	def getcoursesenrollment (courseid, role)
		#puts 'getcoursesenrollment'
		
		per_page = config["per_page"].to_s
    	
      #	app_url = base_url + "/api/v1/courses/"+courseid.to_s+"/enrollments?role={'"+role.to_s+"'}"
       #	app_url = base_url + "/api/v1/courses/"+courseid.to_s+"/enrollments?role[]=['"+role.to_s+"']"
      	app_url = base_url + "/api/v1/courses/"+courseid.to_s+"/enrollments?role[]="+role.to_s
      	puts app_url
    	data_collected = 0  
       	#the array of JSON objects returned from the Courses API calls  
  	  	data_json_arr = []  
  
		exists = true
	    while exists
	    	begin
	        response = RestClient.get app_url, :Authorization => auth_token   {|response, request, result| response }
	        
	        rescue => e
  				e.response
  				puts 'seema:'+e.response
			end
	        if (response.nil?) 
	        	return data_json_arr
	        end
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
	    return data_json_arr
	end

	def getcoursessections (courseid)
		#puts 'getcoursesenrollment'
		
		per_page = config["per_page"].to_s
    	
      #	app_url = base_url + "/api/v1/courses/"+courseid.to_s+"/enrollments?role={'"+role.to_s+"'}"
       #	app_url = base_url + "/api/v1/courses/"+courseid.to_s+"/enrollments?role[]=['"+role.to_s+"']"
      	app_url = base_url + "/api/v1/courses/"+courseid.to_s+"/sections"
      	puts app_url
    	data_collected = 0  
       	#the array of JSON objects returned from the Courses API calls  
  	  	data_json_arr = []  
  
		exists = true
	    while exists
	    	begin
	        response = RestClient.get app_url, :Authorization => auth_token   {|response, request, result| response }
	        
	        rescue => e
  				e.response
  				puts e.response
			end
	        if (response.nil?) 
	        	return data_json_arr
	        end
	        #puts response
	        links = response.headers[:link]  
	        next_link =""
		        
	        if(!links.nil?)
		        all_links = links.split(",")  
		        #the next link is the 1st in the Links header if there are more pages in the pagination structure, and the actual URL is inside the  
		        #first in the chunk that's returned. It should look like this:  
		        #Link: <https://<canvas-instance>/api/v1/accounts/:id/courses?page=2&per_page=50>; rel="next"  
		        #next_link = all_links[0].split(';')[0].gsub(/\<|\>/, "")  
		       #next_link =""
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
	        end
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


	def getallterms (accountid)
		puts 'getallterms'
		
      	url = base_url + "/api/v1/accounts/"+accountid.to_s+"/terms?per_page=100"

      	puts url
      	response = RestClient.get url, :Authorization => auth_token 
      	data_json = JSON.parse response.to_s  
      	puts data_json
      	return data_json
	end

	def getcoursesenrollment_new (courseid, role)
		puts 'getcoursesenrollment'
		
		per_page = config["per_page"].to_s
    	
    	puts base_url

      #	app_url = base_url + "/api/v1/courses/"+courseid.to_s+"/enrollments?role={'"+role.to_s+"'}"
       	app_url = base_url + "/api/v1/courses/"+courseid.to_s+"/enrollments?role[]="+role.to_s
      #	app_url = base_url + "/api/v1/courses/"+courseid.to_s+"/enrollments"

     
      	puts app_url
    	data_collected = 0  
       	#the array of JSON objects returned from the Courses API calls  
  	  	data_json_arr = []  
  
		exists = true
	    while exists
	    	begin
	        response = RestClient.get app_url, :Authorization => auth_token   {|response, request, result| response }
	        
	        rescue => e
  				e.response
  				puts 'seema:'+e.response
			end
	        if (response.nil?) 
	        	return data_json_arr
	        end
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
	    return data_json_arr
	end	


end
