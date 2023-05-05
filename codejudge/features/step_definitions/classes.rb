Given('the Instructor is authenticated') do
  @browser.navigate.to(@url)
  @browser.find_element(:id, "username").send_keys("ritchey")
  @browser.find_element(:id, "password").send_keys("password")
  @browser.find_element(:id, "login_btn").click()
  sleep(1)
end

Given('Instructor is on professors view') do
  @browser.navigate.to(@url + "instructors/")
end

  
Then('they should see a list of classes') do
  rows = @browser.find_elements(:class, "grouptitle")
  # Iterate over each row and check if the title is present
  contains_classes = false
  rows.each do |row|
    class_title = row.text
    puts class_title
    if class_title.include?("TestClass")
      contains_classes = true
      break # We can stop iterating once we find a match
    end
  end

  unless contains_classes
    puts "No classes with title 'TestClass' found"
    raise "Fail"
  end
end



  