require 'csv'  
require_relative 'api/account' 
require_relative 'util/utility' 

def getadmindata(env_type)
  puts 'getadmindata'
  
  all_Accounts_arr =[]
  rep_arr_data =[]

  accountobj = Account.new("config/config.yaml",env_type)

  #puts accountobj
  # get root account
  root_account_arr_data= accountobj.getrootaccount
  #puts root_account_arr_data
  #puts root_account_arr_data.length
  
  # add root account in consolidated account array
  all_Accounts_arr.concat root_account_arr_data

  root_account_arr_data.each { |x|  
      #puts "calling: #{x["id"]}"
      all_Accounts_arr.concat  accountobj.getsubaccount(x["id"])
    }  

  puts "Total no of accounts:#{all_Accounts_arr.length}"
 # i = 0

  all_Accounts_arr.each do |account|
    #admins = Canvas.adminbyAccount(account["id"])
    admins = accountobj.adminbyAccount(account["id"])

    admins.each do |admin|
       # puts admin
        reportdata =Hash.new  
        reportdata['User Id']=admin['user']['sis_user_id']
        reportdata['Login Id']=admin['user']['login_id']
        reportdata['Employee Name']=admin['user']['name']
        reportdata['Role']=admin['role']
        reportdata['Canvas AccountId']=account["id"]
        reportdata['Account Id']=account["sis_account_id"]
        reportdata['Canvas ParentId']=account["parent_account_id"]
        
        reportdata['Parent Account Id']= ''
        reportdata['Parent Account Name']=''

        if !(account["parent_account_id"].nil?) 
          #puts account["parent_account_id"]
          all_Accounts_arr.each do |account_loop|
            if (account_loop["id"] == account["parent_account_id"])
              #puts account_loop
              reportdata['Parent Account Id']= account_loop["sis_account_id"]
              reportdata['Parent Account Name']= account_loop["name"]
              break
            end
          end
        end
        

        reportdata['Account Name']=account["name"]
         
        #reportdata['LoginId']=admin['user']['login_id']
       
        rep_arr_data.push(reportdata)
       
    end
   #  i += 1
   #     if (i >= 100)
   #      break
   #     end
  end
  puts rep_arr_data.length
  return rep_arr_data
end



def createcsv_old(arydata,filepath)
  puts "start:createcsv :#{arydata.length}"

  column_names =[]
  if !(arydata.first.nil?)
    column_names = arydata.first.keys
#   puts column_names
  end

 CSV.open(filepath, "wb") do |csv|
  csv << column_names
    arydata.each do |row|
      csv << row.values
    end
  end
  puts "end:createcsv :Report: #{filepath} generated"
end

#######main program begins#####

## This script will generate a report/listing of users with elevated access in the Canvas ####

puts "Which env you need to run the script (For prod, enter prod, For Test, enter test) ? "
env_type = gets

env_type= env_type.chomp

puts "Please provide path of output data file:"

outputdatafilefolder = gets

outputdatafilefolder = outputdatafilefolder.chomp


Utility.validateString(env_type,["test","prod"],'Please provide valid env type')

Utility.validateFile(outputdatafilefolder,'Please provide valid path of output data file.')

outputfilename = "#{outputdatafilefolder}/elevated_access_report_#{env_type}-#{Time.now.strftime('%Y%m%d-%H%M%S')}.csv"

puts outputfilename

puts 'report generation process:start'

rep_arr_data = getadmindata(env_type)

#createcsv(rep_arr_data,outputfilename)

Utility.createcsv(rep_arr_data,outputfilename,nil)


puts 'report generation process:end'

### end####


