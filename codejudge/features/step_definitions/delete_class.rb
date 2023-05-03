#Iteration-5 Spring-2023
Given('the Instructor has access') do
    @browser.navigate.to(@url)
    @browser.find_element(:id, "username").send_keys("ritchey")
    @browser.find_element(:id, "password").send_keys("password")
    @browser.find_element(:id, "login_btn").click()
    sleep(1)
  end
  
  Given('the Instructor redirects to the classes page') do
    @browser.navigate.to(@url + "instructors/")
  end

  When('they click on delete button') do
    classes_list_table = @browser.find_element(:id, "classes_list_table")
    delete_class_button = classes_list_table.find_element(:link_text, "Delete")
    @delete_class_href = delete_class_button.attribute("href")
    delete_class_button.click()
  end
  

  Then('they should see a new page for destroying a class') do
    current_url = @browser.current_url
    puts "<><>"+current_url
    raise "Fail" unless current_url.include?("instructors")
  end

  Given('the Instructor redirects to the destroy page') do
    puts @delete_class_href
    @browser.navigate.to(@delete_class_href)
  end 

  When('they click on edit this group') do
    edit_group_link = @browser.find_element(:link_text, "Edit this group")
    @edit_group_href = edit_group_link.attribute("href")
    edit_group_link.click()
  end

  Then('they should see a edit page for editing the class') do
    current_url = @browser.current_url
    puts current_url
    raise "Fail" unless current_url.include?(@delete_class_href)
  end

  When('they click on Back to groups') do
    back_to_groups_link = @browser.find_element(:link_text, "Back to groups")
    @back_to_groups_href = back_to_groups_link.attribute("href")
    back_to_groups_link.click()
  end

  Then('they should see a groups page') do
    current_url = @browser.current_url
    puts current_url
    raise "Fail" unless current_url.include?(@delete_class_href)
  end

  # When('they click on destroy this group button') do
  #   pending # Write code here that turns the phrase above into concrete actions
  # end
  
  # Then('they should see a classes table without deleted group') do
  #   pending # Write code here that turns the phrase above into concrete actions
  # end