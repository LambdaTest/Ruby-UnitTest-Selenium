require ('rubygems')
require ('parseconfig')

class ReadConfig

	#function to read .conf file
	def getDetails(key)		
		my_config = ParseConfig.new( File.expand_path(File.dirname(__FILE__)) +'/config.conf') 
		value = my_config.params[key]
		return value
	end
end	

