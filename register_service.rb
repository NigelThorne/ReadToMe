require 'rubygems'
require 'win32/service'

include Win32

SERVICE_NAME = 'ruby_tts_service'

# delete the service
# NOTE: if the services applet is up during this operation, the service won't be removed from that ui
# unitil you close and reopen it (it gets marked for deletion)
#Service.delete(SERVICE_NAME)
#path = File.expand_path(File.dirname(__FILE__)).gsub('/','\\')

# Create a new service
Service.create({
  :service_name       => SERVICE_NAME,
  :host               => nil,
  :service_type       => Service::WIN32_OWN_PROCESS,
  :description        => 'A tts web service',
  :start_type         => Service::AUTO_START,
  :error_control      => Service::ERROR_NORMAL,
  :binary_path_name   => "\"#{`where ruby`.chomp}\" -C \"#{`echo %cd%`.chomp}\" windows_service.rb",
  :load_order_group   => 'Network',
  :dependencies       => nil,
  :display_name       => SERVICE_NAME
})

Service.start(SERVICE_NAME)
