Given('the admin has access') do
    @browser.navigate.to(@url)
    @browser.find_element(:id, "username").send_keys("test")
    @browser.find_element(:id, "password").send_keys("password")
    @browser.find_element(:id, "login_btn").click()
    sleep(1)
  end
  
  
  Given('the admin redirects to the problems page') do
   @browser.navigate.to(@url + "problems/")
  end

  When('they click on new problem button') do
    button_container = @browser.find_element(:id, "new_problem_button-container")
    new_problem_button = button_container.find_element(:id, "new_problem_button")
    new_problem_button.click()
  end

  Then('they should see a form for creating a new problem') do
    raise "Fail" if @browser.current_url == @url
  end