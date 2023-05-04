#Iteration-5 Spring-2023
Given('the Instructor has access for class') do
    @browser.navigate.to(@url)
    @browser.find_element(:id, "username").send_keys("ritchey")
    @browser.find_element(:id, "password").send_keys("password")
    @browser.find_element(:id, "login_btn").click()
    sleep(1)
  end
  
  Given('the Instructor Redirects to the classes page') do
    @browser.navigate.to(@url + "instructors/")
    current_url = @browser.current_url
    puts "<><>"+current_url
  end

  When('they click on class code') do
    classes_list_table = @browser.find_element(:id, "classes_list_table")
    first_row = classes_list_table.find_element(:class, "grouptitle")
    @class_link = first_row.find_element(:tag_name, "a")
    @class_link.click()
    sleep(1)
  end
  
  
  Then('they should see a new page for the class details') do
    current_url = @browser.current_url
    puts "<><>"+current_url
    raise "Fail" unless current_url.include?("details")
  end


  When('they click on add problems') do
    @add_prob = @browser.find_element(:link_text, "Add Problems")
    @add_prob.click()
    sleep(1)

  end

  Then('they should see a new page for adding the problems to the class') do
    current_url = @browser.current_url
    puts current_url
    raise "Fail" unless current_url.include?("addproblem")
  end

  When('they click on add students') do
    @browser.navigate.to(@url + "instructors/")
    classes_list_table = @browser.find_element(:id, "classes_list_table")
    first_row = classes_list_table.find_element(:class, "grouptitle")
    @class_link = first_row.find_element(:tag_name, "a")
    @class_link.click()
    sleep(1)
    @add_prob = @browser.find_element(:link_text, "Add Students")
    @add_prob.click()
    sleep(1)
  end

  Then('they should see a new page for adding the students to the class') do
    current_url = @browser.current_url
    raise "Fail" unless current_url.include?("addition")
  end
