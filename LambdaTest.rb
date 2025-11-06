require 'rubygems'
require 'selenium-webdriver'
require 'test/unit'
require_relative "readConf"

class AdvanceTest < Test::Unit::TestCase
  def setup
    config = ReadConfig.new()

    lt_user = ENV['LT_USERNAME'] || config.getDetails('LT_USERNAME')
    lt_appkey = ENV['LT_ACCESS_KEY'] || config.getDetails('LT_ACCESS_KEY')
    lt_os = ENV['LT_OPERATING_SYSTEM'] || config.getDetails('LT_OPERATING_SYSTEM')
    lt_browser = ENV['LT_BROWSER'] || config.getDetails('LT_BROWSER')
    lt_browser_version = ENV['LT_BROWSER_VERSION'] || config.getDetails('LT_BROWSER_VERSION')

    lt_options = {
      "build" => "LambdaTestSampleApp",
      "name" => "RubyRSpecTestSample",
      "platformName" => lt_os,
      "selenium_version" => "4.38.0",
      "w3c" => true,
      "plugin" => "ruby-rspec"
    }

    # ✅ Use the correct Selenium 4 Options object
    case lt_browser.downcase
    when 'chrome'
      options = Selenium::WebDriver::Options.chrome
    when 'firefox'
      options = Selenium::WebDriver::Options.firefox
    when 'edge'
      options = Selenium::WebDriver::Options.edge
    else
      raise "Unsupported browser: #{lt_browser}"
    end

    options.browser_version = lt_browser_version
    options.add_option('LT:Options', lt_options)

    puts "Starting test with: #{lt_browser} #{lt_browser_version} on #{lt_os}"

    # ✅ Create remote WebDriver (Selenium 4 syntax)
    @driver = Selenium::WebDriver.for(
      :remote,
      url: "https://#{lt_user}:#{lt_appkey}@hub.lambdatest.com/wd/hub",
      options: options
    )

    @driver.manage.window.maximize
    @driver.navigate.to("https://lambdatest.github.io/sample-todo-app/")
  end

  def test_Login
    item_name = "Yey, Lets add it to list"

    @driver.find_element(:name, 'li1').click
    @driver.find_element(:name, 'li2').click
    @driver.find_element(:id, 'sampletodotext').send_keys(item_name)
    @driver.find_element(:id, 'addbutton').click

    get_item_name = @driver.find_element(:xpath, '/html/body/div/div/div/ul/li[6]/span').text
    assert_equal(item_name, get_item_name)
  end

  def teardown
    @driver.quit if @driver
  end
end
