# Load the rails application
require File.expand_path('../application', __FILE__)
require File.dirname(__FILE__) + '/lib/plugins/eforsys_rj_report/lib/rj_report.rb'
require File.dirname(__FILE__) + '/lib/plugins/eforsys_stored_procedures/lib/stored_procedures.rb'

# Initialize the rails application
Gebos::Application.initialize!
#include RjReport
include ApplicationHelper
include ActionView::Helpers::NumberHelper
ENV['JAVA_HOME'] = "/usr/lib/jvm/java-7-oracle"