Given('the Instructor is authenticated') do
  @browser.navigate.to(@url)
  @browser.find_element(:id, "username").send_keys("instructor")
  @browser.find_element(:id, "password").send_keys("password")
  @browser.find_element(:id, "login_btn").click()
  sleep(1)
end

Given('Instructor is on professors view') do
  @browser.navigate.to(@url + "instructors/")
end

  
Then('they should see a list of classes') do
    table_list = @browser.find_element(:id, "classes_list_table")
    raise "Fail" if !table_list.displayed?
end




  