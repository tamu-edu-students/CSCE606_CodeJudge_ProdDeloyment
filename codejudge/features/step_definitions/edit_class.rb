# The following tests are for Iteration-5 Spring-2023
Given('the instructor has access to edit existing class') do
    @browser.navigate.to(@url)
    @browser.find_element(:id, "username").send_keys("ritchey")
    @browser.find_element(:id, "password").send_keys("password")
    @browser.find_element(:id, "login_btn").click()
    sleep(1)
  end

Given('the instructor routes to classes page') do
    @browser.navigate.to(@url + "instructors/")

  end

When('they click on modify button') do
    table_row = @browser.find_element(:xpath, "//table/tbody/tr/td[a[text()='Modify']]/..")
    modify_link = table_row.find_element(:link_text, "Modify")
    modify_link.click()
    sleep(1)
end

Then('they should see a form editing class details') do
    expect(@browser.current_url).to match /.*\/edit$/
    raise "Fail" if @browser.find_element(:id, "classDetails").nil?
end