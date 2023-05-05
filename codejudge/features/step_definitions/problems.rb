# The following tests are for Iteration-2 Spring-2023
Given('the admin is authenticated') do
  @browser.navigate.to(@url)
  @browser.find_element(:id, "username").send_keys("ritchey")
  @browser.find_element(:id, "password").send_keys("password")
  @browser.find_element(:id, "login_btn").click()
  sleep(1)
  # body_element = @browser.find_element(:tag_name, 'body')
  #
  # # Get the visible text
  # visible_text = body_element.text
  #
  # # Print the text
  # puts visible_text
end

Given('the admin goes to the problems page') do
  @browser.navigate.to(@url + "problems/")
end

Given('they click on the {string} button') do |string|
  @browser.find_element(:id, string).click()
  sleep(1)
end

Given('they enter the problem details') do
  pending # Write code here that turns the phrase above into concrete actions
end

When('they click on the {string} button') do |string|
  @browser.find_element(:id, string).click()
end

Then('the problem should be visible in the list') do
  pending # raise "Fail" if @browser.find_element(:id, "problems")
end

Given('a certain problem exists') do
  pending # Write code here that turns the phrase above into concrete actions
end

Given('they click on the {string} button of a certain problem') do |string|
  pending # Write code here that turns the phrase above into concrete actions
end

Given('they enter the new values') do
  pending # Write code here that turns the phrase above into concrete actions
end

Then('the problem should be updated to the new values') do
  pending # Write code here that turns the phrase above into concrete actions
end

Then('the problem should not be visible in the list any more') do
  pending # Write code here that turns the phrase above into concrete actions
end

Then('they should see a list of problems with tags and difficulty') do

  # rows = @browser.find_elements(:xpath, "//tbody/tr")
  #
  # # Iterate over each row and extract the problem title
  # rows.each do |row|
  #   title_link = row.find_element(:tag_name, "a")
  #   problem_title = title_link.text
  #   # puts problem_title # Or do something else with the title
  # end
  rows = @browser.find_elements(:xpath, "//tbody/tr")

  # Iterate over each row and check if the title contains "BFS"
  contains_bfs = false
  rows.each do |row|
    prob_tag = row.find_element(:id, "probTag")
    raise "Fail" if row.find_element(:id, "probDifficulty").nil?
    problem_tag = prob_tag.text
    if problem_tag.include?("BFS")
      contains_bfs = true
      break # We can stop iterating once we find a match
    end
  end

  unless contains_bfs
    raise "Fail"
  end
end