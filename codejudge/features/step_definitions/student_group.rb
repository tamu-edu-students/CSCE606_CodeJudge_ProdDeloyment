
Given('the students are authenticated') do
    @browser.navigate.to(@url)
    @browser.find_element(:id, "username").send_keys("praveen")
    @browser.find_element(:id, "password").send_keys("password")
    @browser.find_element(:id, "login_btn").click()
    sleep(1)
  end
  
  Given('the student goes to the groups page') do
    @browser.navigate.to(@url + "student_groups/")
  end

  When('they enter correct group code') do
    solution_file_path = 'HH79KD'
    @browser.find_element(:id, 'classcode').send_keys(solution_file_path)
    end
    
  When('they click on join class button') do
    @browser.find_element(:name, 'commit').click()
    sleep(1)
    end
  
  Then('they should able to join the group') do
      current_url = @browser.current_url
      puts "<><>"+current_url
      value=@browser.find_element(:class,"row").find_element(:tag_name,"p").text=="Joined class successfully"
      raise "Fail" unless value
    end

    Then('they able to see the classname in page') do
      raise "Fail" unless @browser.find_element(:link_text,"TestClass")
    end
 
  When('they enter incorrect group code') do
      solution_file_path = "kjgfigi"#'HH79KD'
      @browser.find_element(:id, 'classcode').send_keys(solution_file_path)
      end
      
  When('they click on joinclass button') do
      @browser.find_element(:name, 'commit').click()
      sleep(1)
      end
    
  Then('they should not able to join the group') do
        current_url = @browser.current_url
        puts "<><>"+current_url
        value=@browser.find_element(:class,"row").find_element(:tag_name,"p").text=="class with given class code does not exist !"
        raise "Fail" unless value
      end
   