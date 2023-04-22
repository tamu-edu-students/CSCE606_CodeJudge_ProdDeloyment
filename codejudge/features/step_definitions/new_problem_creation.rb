

  Given('the instructor redirects to the problems page') do
    @browser.navigate.to(@url + "problems/")
  end

  When('they click on new problem button') do
    @browser.find_element(:id, "newProbBtn").click()
    sleep(1)
  end

  Then('they should see a form for creating a new problem') do
    raise "Fail" if @browser.find_element(:id, "problem_form").nil?
  end