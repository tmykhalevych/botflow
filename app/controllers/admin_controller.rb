require_relative "application_controller.rb"

module App
  class AdminController < ApplicationController
    def commence
      if !admin.logged_in
        admin.state = Administrator.state(:admin_login)
        admin.save
        send_text_response(t.admin.enter_pass)
      else
        send_text_response(t.admin.already_logged)
      end
    end

    def logout
      admin.logged_in = false
      admin.save
      send_text_response(t.admin.logged_out(admin.first_name))
    end

    def login
      if message.text == CONFIG[:ADMIN_PASSWORD] then
        admin.logged_in = true
        admin.state = Administrator.state(:idle) # TODO: Think, if we need to do this!!
        admin.save
        send_text_response(t.admin.logged_in(admin.first_name))
      else
        admin.state = Administrator.state(:idle) # TODO: Think, if we need to do this!!
        admin.save
        send_text_response(t.admin.wrong_pass)
      end
    end

    def exit
      admin.state = Administrator.state(:idle)
      admin.work_with_product = ""
      admin.save
      send_text_response(t.admin.exit_msg)
    end
  end
end
