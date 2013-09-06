# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Dame09plus::Application.initialize!

Date::DATE_FORMATS[:default]    = "%Y-%m-%d"
Time::DATE_FORMATS[:default]    = "%Y-%m-%d %H:%M"
Time::DATE_FORMATS[:short_date] = "%b %d"