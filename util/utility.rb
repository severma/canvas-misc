class Utility

	# all methods in this block are static
  class << self

	def isNotValid(input)
		if (input.nil? or input.strip.length <= 0)
			return true
		else
			return false
		end

	end
	
	def die(msg)
	  puts msg
	  exit
	end

	def validateFile(inputdatafilename,errormsg)
		if(!File.exist?(inputdatafilename))
			die(errormsg)
		end
	end
	
	def validateString(input, validvalues, errormsg)
		
		if (input.nil? or validvalues.nil?)
			die(errormsg)
		end
		exists = 'false'
		validvalues.each { |x| 
			#puts x 
			if(x == input)
				exists = 'true'
			end
		}
		if (exists == 'false')
			die(errormsg)
		end

	end

	def createcsv(arydata,filepath,headers)
		puts "start:createcsv :#{arydata.length}"
		
		if(headers.nil?)
			headers =[]
		  	if !(arydata.first.nil?)
		    	headers = arydata.first.keys
			#   puts column_names
		  	end
		end
		
		 CSV.open(filepath, "wb") do |csv|
		  csv << headers
		    arydata.each do |row|
		      csv << row.values
		    end
		  end
		  puts "end:createcsv :Report: #{filepath} generated"
		end
	
	end


end
