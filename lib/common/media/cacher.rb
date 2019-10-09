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
      send_text_response(t.admin.logged_out(admin.fir