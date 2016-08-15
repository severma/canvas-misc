require 'csv'  
require_relative 'api/user' 
require_relative 'util/utility' 

def updateuser(env_type,inputdatafilename)

	userobj = User.new("config/config.yaml",env_type)

	rep_arr_data =[]

	CSV.foreach(inputdatafilename,:encoding => 'ISO-8859-1') do |row|
		#puts row.inspect
		next if row[0]=='canvas_user_id' # skip header row
		
		users = userobj.getuserlogins(row[0])

		users.each do |user|
			puts user
			userupdate =nil
			if(user['unique_id'] == row[2])
				parameters = Hash.new 
				
				parameters['login[sis_user_id]']=''
				
				userupdate = userobj.updateuserlogin("1",user['id'],parameters)
				
				#puts userupdate
				
				outparameters = Hash.new 
				outparameters['id']= user['id']
				outparameters['canvas_user_id']=row[0]
				outparameters['user_id']=row[1]
				outparameters['login_id']=row[2]
				outparameters['first_name']=row[3]
				outparameters['last_name']=row[4]
				outparameters['full_name']=row[5]
				outparameters['sortable_name']=row[6]
				outparameters['short_name']=row[7]
				outparameters['email']=row[8]
				outparameters['status']=row[9]
				outparameters['PreUpdate_sisid']=user['sis_user_id']
				
				if (!userupdate.nil?)
					outparameters['id']= userupdate['id']
					outparameters['AfterUpdate_sisid']=userupdate['sis_user_id']
				end
				rep_arr_data.push(outparameters)
			end 
		end
	end
	return rep_arr_data
end


#######main program begins#####
## This script will update the provided users SIS ID as blank ####

puts "Which env you need to run the script (For prod, enter prod, For Test, enter test) ? "
env_type = gets

env_type= env_type.chomp

Utility.validateString(env_type,["test","prod"],'Please provide valid env type')

puts "Please provide Name of input data file with full path:"

datafilename = gets

datafilename = datafilename.chomp

inputdatafilename="#{datafilename}"

Utility.validateFile(inputdatafilename,'Please provide valid input data file.')

outputfilename = "#{datafilename}_out_#{env_type}-#{Time.now.strftime('%Y%m%d-%H%M%S')}.csv"

puts inputdatafilename

puts 'update user login process:start'

rep_arr_data = updateuser(env_type,inputdatafilename)
fileheaders =["id","canvas_user_id","user_id","login_id","first_name","last_name","full_name","sortable_name","short_name","email","status","PreUpdate_sisid","AfterUpdate_sisid"]

Utility.createcsv(rep_arr_data,outputfilename,fileheaders)

puts 'update user login process:end'

### end####