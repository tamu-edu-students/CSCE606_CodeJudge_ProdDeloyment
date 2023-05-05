Given('the instructor has access to ratings page') do
  @browser.navigate.to(@url)
  @browser.find_element(:id, "username").send_keys("instructor_5")
  @browser.find_element(:id, "password").send_keys("password")
  @browser.find_element(:id, "login_btn").click()
  sleep(1)
end

Given("the instructor is on rating page") do
  @browser.navigate.to @url + "rating/"
  puts "current_url" + @browser.current_url
end

Then("the table should have the following contents") do
  table = @browser.find_element(:xpath, "//table")
  rows = table.find_elements(tag_name: "tr")
  contains_all_cols = false

  rows.each_with_index do |row, row_index|
    cells = row.find_elements(tag_name: "td")
  
    # Check that the row has the expected number of cells
    if cells.length == 3
      rank = nil
      username = nil
      rating = nil
    
      cells.each do |cell|
        if cell.text =~ /^\d+$/ # Check for Rank column
          rank = cell.text.to_i
        elsif cell.text =~ /^[a-zA-Z]+$/ # Check for Username column
          username = cell.text
        elsif cell.text =~ /^.+$/ # Check for Rating column
          rating = cell.text.to_f
        end
      end
    
      # Check that all the columns have been found
      if rank && username && rating
        contains_all_cols = true
        break
      end
    end
  end
  
  unless contains_all_cols
    raise "Fail"
  end
end



When('the instructor clicks on the username of the 3rd student in the table') do
  student_index = 3
  @browser.find_element(css: "tbody tr:nth-child(#{student_index}) td:nth-child(5)").click()
end

Then('the instructor should be redirected to the student details page of the 3rd student') do
  student_index = 3
  expected_url = @url + "users/#{student_index}"
  expect(@browser.current_url).to eq(expected_url)
end





