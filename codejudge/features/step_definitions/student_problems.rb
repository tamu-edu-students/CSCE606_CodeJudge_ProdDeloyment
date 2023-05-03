
Given('the student is authenticated') do
    @browser.navigate.to(@url)
    @browser.find_element(:id, "username").send_keys("praveen")
    @browser.find_element(:id, "password").send_keys("password")
    @browser.find_element(:id, "login_btn").click()
    sleep(1)
  end
  
  Given('the student goes to the problems page') do
    @browser.navigate.to(@url + "problems/")
  end

  When('they click on problem name') do
    @probTable = @browser.find_element(:id, "probTitle")
    @probText=@probTable.text
    @probTablehref = @probTable.attribute("href")
    @probTable.click()
    sleep(1)
  end
  
  Then('they should see a problem page to attempt') do
    current_url = @browser.current_url
    puts "<><>"+current_url
    raise "Fail" unless current_url.include?(@probTablehref)
  end

  When('they upload the solution file') do
    solution_file_path = '/Users/praveenkumar/Desktop/SE/test.py'
    @browser.find_element(:id, 'attempt_sourcecode').send_keys(solution_file_path)
    end
    
  When('they click on submit button') do
    @browser.find_element(:name, 'commit').click()
    sleep(1)
    end
  
  Then('they should see a solution page to attempt') do
      current_url = @browser.current_url
      puts "<><>"+current_url
      raise "Fail" unless current_url.include?("attempts")
    end
  When('they click on back to attempts') do
      back= @browser.find_element(:link_text, "Back to Attempts")
      @back_href = back.attribute("href")
      back.click()
      sleep(1)
  end
  Then('they should go to attempts page') do
    current_url = @browser.current_url
    puts "<><>"+current_url
    raise "Fail" unless current_url.include?(@back_href)
  end

  Then('they should find the problem in attempts page') do
    current_url = @browser.current_url
    raise "Fail" unless @browser.find_element(:link_text,@probText)
  end
    
    