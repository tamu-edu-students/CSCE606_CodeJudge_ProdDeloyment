Given('the instructor has access') do
    @browser.navigate.to(@url)
    @browser.find_element(:id, "username").send_keys("instructor")
    @browser.find_element(:id, "password").send_keys("password")
    @browser.find_element(:id, "login_btn").click()
    sleep(1)
  end
  
  
  Given('the instructor redirects to the classes page') do
   @browser.navigate.to(@url + "instructors/")
  end

  When('they click on new class button') do
    classes_list_table = @browser.find_element(:id, "classes_list_table")
    new_class_button = classes_list_table.find_element(:id, "new_class_button")
    new_class_button.click()
  end

  Then('they should see a form for creating a new class') do
    raise "Fail" if @browser.current_url == @url
  end