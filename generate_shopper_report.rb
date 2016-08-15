require 'csv'  
require_relative 'api/account' 
require_relative 'api/course' 
require_relative 'util/utility' 

def getcanvasdata(env_type, all_terms_arr)
    puts 'getcanvasdata'
    
    all_Accounts_arr =[]
    rep_arr_data =[]

    accountobj = Account.new("config/config.yaml",env_type)
    courseobj = Course.new("config/config.yaml",env_type)

    #puts accountobj
    # get root account
    root_account_arr_data= accountobj.getrootaccount
    #puts root_account_arr_data
    #puts root_account_arr_data.length
    
    # add root account in consolidated account array
    all_Accounts_arr.concat root_account_arr_data

    #root_account_arr_data.each { |x|  
        #puts "calling: #{x["id"]}"
     #   all_Accounts_arr.concat  accountobj.getsubaccount(x["id"])
    #}  

    puts "Total no of accounts:#{all_Accounts_arr.length}"
   # i = 0

   all_canvas_terms_arr =[] 
    root_account_arr_data.each { |x|  
      termdata =Hash.new
      termdata = courseobj.getallterms(x["id"])
      all_canvas_terms_arr.concat termdata['enrollment_terms']
    }

  puts "Total no of terms in Canvas:#{all_canvas_terms_arr.length}"

#all_terms_arr=["201601"]
 
term = [];
 all_courses_arr=[]
all_terms_arr.each do |canvasterm|
  puts canvasterm
  all_canvas_terms_arr.each do |term_loop|
    if (term_loop["sis_term_id"] == canvasterm)
      #puts account_loop
      term = term_loop
      break
    end
  end
  puts term
 puts term['id']
 puts term['name']

  all_Accounts_arr.each do |account|
    courses = courseobj.getcourses(account["id"],term['id'])
    #puts "Total no of courses:#{courses.length}"
    courses.each do |course|
      if (all_courses_arr.include? course["id"] )
        next
      else
        all_courses_arr.push course["id"]
      end
      puts 'call enrollment for courseid::'+course["id"].to_s
      
      enrollments = courseobj.getcoursesenrollment(course["id"],'Shopper')
      puts "Total no of enrollments:#{enrollments.length}"
      sections = courseobj.getcoursessections(course["id"])

      enrollments.each do |enrollment|
       # if(enrollment['role']='Shopper')
        
          reportdata =Hash.new 
          reportdata['Term Id']=term['id']
          reportdata['Term Name']=term['name']
          reportdata['Canvas AccountId']=account["id"]
          reportdata['Canvas ParentId']=account["parent_account_id"]

          reportdata['Parent Account Id']= ''
          reportdata['Parent Account Name']=''

            if !(account["parent_account_id"].nil?) 
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
          reportdata['Course Id']=course["id"]
          reportdata['Course Name']=course["name"]
       #   reportdata['Course Section Id']=enrollment["course_section_id"]
          if !(enrollment["course_section_id"].nil?)
            sections.each do |section|
              if (section["id"] == enrollment["course_section_id"])
                reportdata['Course Section Id']= enrollment["course_section_id"]
                reportdata['Course Section Name']= section["name"]
                break
              end
            end
          end

          reportdata['User Id']=enrollment["user"]['sis_user_id']   
          reportdata['Login Id']=enrollment["user"]['login_id']   
          reportdata['Employee Name']=enrollment['user']['name']
          reportdata['Role']=enrollment['role']

        rep_arr_data.push(reportdata)

     # end
      end

    end # end of course

   end # end of account
 
  end # end of terms
  puts rep_arr_data.length
  puts "Total No of Users ::#{rep_arr_data.length}"
  puts "Total No of Courses ::#{all_courses_arr.length}"
  return rep_arr_data

end # end of main method


#######main program begins#####
## This report generated list of users with shopper role for a specific term ####
puts "Which env you need to run the script (For prod, enter prod, For Test, enter test) ? "
env_type = gets

env_type= env_type.chomp

puts "Please provide path of output data file:"

outputdatafilefolder = gets

outputdatafilefolder = outputdatafilefolder.chomp

all_terms_arr = Array.new

puts "Please provide Canvas Term Id to generate report for(e.g 201601, 201602,201602-H5A). When you\'re finished, press enter on an empty line"
canvastermid= gets.chomp
while canvastermid != ''
  all_terms_arr.push  canvastermid.to_s
  canvastermid = gets.chomp
end

puts "You entered Canvas Term Id:#{all_terms_arr}"
if (all_terms_arr.length == 0)
  Utility.die("Please provide atleast one valid Canvas Term Id.")
end

Utility.validateString(env_type,["test","prod"],'Please provide valid env type')

Utility.validateFile(outputdatafilefolder,'Please provide valid path of output data file.')

outputfilename = "#{outputdatafilefolder}/canvas-shopperlist_report_#{env_type}-#{Time.now.strftime('%Y%m%d-%H%M%S')}.csv"

puts outputfilename

puts 'report generation process:start'


rep_arr_data = getcanvasdata(env_type,all_terms_arr)

Utility.createcsv(rep_arr_data,outputfilename,nil)

puts 'report generation process:end'

### end####


