require 'selenium-webdriver'
require 'simplecov'

# require 'simplecov'
# require 'codecov'

SimpleCov.start
# SimpleCov.formatter = SimpleCov::Formatter::Codecov
SimpleCov.coverage_dir 'coverage/cucumber'

# capabilities = Selenium::WebDriver::Remote::Capabilities.new
# capabilities['platform'] = ENV['SELENIUM_PLATFORM'] || 'ANY'
# capabilities['name'] = 'My first Test'
# capabilities['browserName'] = ENV['SELENIUM_BROWSER'] || 'chrome'
# capabilities['version'] = ENV['SELENIUM_VERSION'] if ENV['SELENIUM_VERSION']

# Create and set capabilities for chrome headless browser
capabilities = [
	Selenium::WebDriver::Remote::Capabilities.chrome(
	  'goog:chromeOptions' => {
		  	    'args' => [ "--headless", "--disable-gpu", "--no-sandbox", "--disable-setuid-sandbox", "--disable-dev-shm-usage" ]
			}
	)
]
browser = Selenium::WebDriver.for :chrome, capabilities: capabilities

Before do |scenario|
	@browser = browser
	@url = "http://127.0.0.1:3000/"
end

at_exit do
	browser.quit
end
