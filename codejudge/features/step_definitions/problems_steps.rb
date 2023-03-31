Given('the admin is authenticated') do
  pending # Write code here that turns the phrase above into concrete actions
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

Then('they should see a list of problems') do
  pending # Write code here that turns the phrase above into concrete actions
end

###above tests are from legacy code, below are newly added ones

Given("the following problems exist:") do |table|
  table.hashes.each do |hash|
    tags = hash['tags'][1..-2].split(',').map { |t| t.strip }
    languages = hash['languages'][1..-2].split(',').map { |l| l.strip }
    problem = FactoryBot.create(:problem, title: hash['title'], level: hash['level'])
    tags.each do |tag|
      problem.tags << Tag.find_by(tag: tag)
    end
    languages.each do |language|
      problem.languages << Language.find_by(language: language)
    end
  end
end


When("I visit the home page") do
  visit root_path
end

Then("I should not see any problems") do
  expect(page).not_to have_selector(".problem")
end

Then("I should not see any difficulty level options") do
  expect(page).not_to have_selector("#difficulty_level_id")
end

Then("I should not see any tag options") do
  expect(page).not_to have_selector("#tag_ids")
end


# View all problems
Then("I should see {string}") do |text|
  expect(page).to have_content(text)
end



Then("I should see all problems") do
  Problem.all.each do |problem|
    expect(page).to have_content(problem.title)
  end
end

# Scenario: No problems exist
Given("no problems exist") do
  Problem.destroy_all
end

Then("I should not see {string}") do |text|
  expect(page).not_to have_content(text)
end

Given("the following tags exist:") do |table|
  table.hashes.each do |hash|
    FactoryBot.create(:tag, tag: hash['tag'])
  end
end


# Scenario: No tags exist
Given("no tags exist") do
  Tag.destroy_all
end



Given("the following difficulty levels exist:") do |table|
  table.hashes.each do |hash|
    FactoryBot.create(:difficulty_level, level: hash['level'])
  end
end



# Scenario: Problems have no difficulty levels
Given("the following tags exist:") do |table|
  table.hashes.each do |tag|
    FactoryBot.create(:tag, tag)
  end
end

Given("the following problems exist with no difficulty levels:") do |table|
  table.hashes.each do |problem|
    tags = problem["tags"].split(",").map(&:strip)
    tag_objects = tags.map { |tag| Tag.find_or_create_by(tag: tag) }
    FactoryBot.create(:problem, title: problem["title"], tags: tag_objects)
  end
end

Then("I should see all problems") do
  expect(page).to have_selector(".problem", count: Problem.all.size)
end





# View problems by tag
When("I select {string} from {string}") do |option, field|
  select option, from: field
end

When("I click {string}") do |button|
  click_button button
end

Then("I should see only problems tagged with {string}") do |tag|
  Problem.joins(:tags).where(tags: { tag: tag }).each do |problem|
    expect(page).to have_content(problem.title)
  end
end

Then("I should not see any problems not tagged with {string}") do |tag|
  Problem.joins(:tags).where.not(tags: { tag: tag }).each do |problem|
    expect(page).not_to have_content(problem.title)
  end
end

# View problems by difficulty level
Then("I should see only problems at difficulty level {string}") do |level|
  Problem.joins(:difficulty_level).where(difficulty_levels: { level: level }).each do |problem|
    expect(page).to have_content(problem.title)
  end
end

Then("I should not see any problems not at difficulty level {string}") do |level|
  Problem.joins(:difficulty_level).where.not(difficulty_levels: { level: level }).each do |problem|
    expect(page).not_to have_content(problem.title)
  end
end

# View problems by tag and difficulty level
Then("I should see only problems tagged with {string} at difficulty level {string}") do |tag, level|
  Problem.joins(:tags, :difficulty_level).where(tags: { tag: tag }, difficulty_levels: { level: level }).each do |problem|
    expect(page).to have_content(problem.title)
  end
end

Then("I should not see any problems not tagged with {string} or not at difficulty level {string}") do |tag, level|
  Problem.joins(:tags, :difficulty_level).where.not(tags: { tag: tag }, difficulty_levels: { level: level }).each do |problem|
  end
end



# Scenario: No difficulty levels exist
Given("no difficulty levels exist") do
  DifficultyLevel.destroy_all
end
