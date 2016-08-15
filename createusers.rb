require 'csv'  
require_relative 'api/user' 
require_relative 'util/utility' 

def createuser(env_type,inputdatafilename)

userobj = User.new("config/config.yaml",env_type)

parameters = Hash.new 

rep_arr_data =[]

#puts inputdatafilename
CSV.foreach(inputdatafilename,:encoding => 'ISO-8859-1') do |row|
	#puts row.inspect
	next if row[0]=='login_ID' # skip header row
	if(Utility.isNotValid(row[0]) or Utility.isNotValid(row[1]) or Utility.isNotValid(row[2]) or Utility.isNotValid(row[3]))
		next
	end
	parameters = Hash.new 
	
	parameters['pseudonym[unique_id]']=row[0].strip
	parameters['pseudonym[password]']=row[1].strip
	parameters['user[name]']=row[2].strip
	parameters['communication_channel[address]']=row[3].strip
	parameters['communication_channel[type]']='email'
	
	user = userobj.createuser("1",parameters)
	parameters['userId']=''
	parameters['status']='Fail'
	if (!user.nil?)
		parameters['userId']=user['id']
		parameters['status']='Pass'
	end
	
	rep_arr_data.push(parameters)
	#puts row.inspect
	#puts parameters
end

return rep_arr_data
end


#######main program begins#####
## This script will create users in the Canvas ####

puts "Which env you need to run the script (For prod, enter prod, For Test, enter test) ? "
env_type = gets

env_type= env_type.chomp

Utility.validateString(env_type,["test","prod"],'Please provide valid env type')

puts "Please provide Name of input data file with full path:"

datafilename = gets

datafilename = datafilename.chomp

inputdatafilename="#{datafilename}"
outputfilename = "#{datafilename}_out_#{env_type}-#{Time.now.strftime('%Y%m%d-%H%M%S')}.csv"

puts inputdatafilename

Utility.validateFile(inputdatafilename,'Please provide valid input data file.')

puts outputfilename

puts 'create user process:start'

rep_arr_data = createuser(env_type,inputdatafilename)

fileheaders =["login_ID","password","Full_Name","email_address","type","userId","status"]

Utility.createcsv(rep_arr_data,outputfilename,fileheaders)

puts 'create user process:end'

### end####