require 'rubygems'
require 'selenium-webdriver'
require 'test/unit'
require_relative  "readConf"

class AdvanceTest < Test::Unit::TestCase

    def setup
		config = ReadConfig.new()	
		lt_user = ENV['LT_USERNAME']
		lt_appkey = ENV['LT_APPKEY']
		lt_os = ENV['LT_OPERATING_SYSTEM']
		lt_browser = ENV['LT_BROWSER']
		lt_browser_version = ENV['LT_BROWSER_VERSION']
		if(lt_user == "" || lt_user == nil)
			lt_user = config.getDetails('LT_USERNAME')
		end
		if(lt_appkey == "" || lt_appkey == nil)
			lt_appkey = config.getDetails('LT_APPKEY')
		end
		if(lt_browser == "" || lt_browser == nil)
			lt_browser = config.getDetails('LT_BROWSER')
		end
		if(lt_os == "" || lt_os ==nil)
			lt_os = config.getDetails('LT_OPERATING_SYSTEM')
		end
		if(lt_browser_version == "" || lt_browser_version == nil)
			lt_browser_version = config.getDetails('LT_BROWSER_VERSION')
		end	
		caps = {						
			:browserName => lt_browser,			
			:version => lt_browser_version,			
			:platform =>  lt_os,
			:name =>  "RubyRSpecTestSample",
			:build =>  "LambdaTestSampleApp",       
			:network =>  true,
			:visual =>  true,
			:video =>  true,
			:console =>  true
		} 	
		puts (caps)
		@driver = Selenium::WebDriver.for(:remote,
			:url => "https://"+lt_user+":"+lt_appkey+"@hub.lambdatest.com/wd/hub",
			:desired_capabilities => caps)
		
		@driver.manage.window.maximize
		
		@driver.get("https://lambdatest.github.io/sample-todo-app/" )
	end

    def test_Login
        item_name = "Yey, Lets add it to list"

        #Click on First Checkbox
        fCheckbox = @driver.find_element(:name, 'li1')
        fCheckbox.submit

        #Click on Second Checkbox
        sCheckbox = @driver.find_element(:name, 'li2')
        sCheckbox.submit
    
        #Enter Item Name 
        itemNameInput = @driver.find_element(:id, 'sampletodotext')
        itemNameInput.send_keys item_name
        
        #Click on Add Button
        addButton = @driver.find_element(:id, 'addbutton')
        addButton.submit

        # Verify Added Item
        getItemName = @driver.find_element(:xpath, '/html/body/div/div/div/ul/li[6]/span').text
		assert_equal(getItemName, item_name )
    end
    
    def teardown
		@driver.quit
	end
	
end
