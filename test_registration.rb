# encoding: UTF-8
# coding: Utf-8

require 'test/unit'
require 'selenium-webdriver'
class TestRegistration < Test::Unit::TestCase
  def setup
    @driver = Selenium::WebDriver.for :chrome
    @url = "http://demo.redmine.org/"
  end

  def teardown
    @driver.quit

  end

  #
  # def test_positive_registration
  #   register_user
  #   expected_text = "Your account has been activated. You can now log in."
  #   actual_text = @driver.find_element(:id, 'flash_notice').text
  #
  #   #sleep 300
  #   assert_equal(expected_text, actual_text)
  # end


  # def test_positive_login
  #   createdLogin = register_user
  #   logout_user
  #   login_user createdLogin
  #
  #   expected_text = "My account"
  #   actual_text = @driver.find_element(:class, 'my-account').text
  #   assert_equal(expected_text, actual_text)
  # end

  def test_create_proj
    createdLogin = register_user
    createdProject = create_new_proj
    expected_text = "Successful creation."
    actual_text = @driver.find_element(:id, 'flash_notice').text
    assert_equal(expected_text, actual_text)

  end


  # def test_positive_logout
  #   createdLogin = register_user
  #   logout_user
  #
  #   expected_text = "Sign in"
  #   actual_text = @driver.find_element(:class, 'login').text
  #   assert_equal(expected_text, actual_text)
  # end


  ######### Helpers

  def register_user
    @driver.navigate.to @url
    @driver.find_element(:class, 'register').click

    login = ('login'+ rand(9999).to_s)

    @driver.find_element(:id, 'user_login').send_keys login
    @driver.find_element(:id, 'user_password').send_keys 'qwerty'
    @driver.find_element(:id, 'user_password_confirmation').send_keys 'qwerty'
    @driver.find_element(:id, 'user_firstname').send_keys 'poiopl'
    @driver.find_element(:id, 'user_lastname').send_keys 'hjhkjl'
    @driver.find_element(:id, 'user_mail').send_keys (login + '@klkl.com')
    @driver.find_element(:name, 'commit').click
    return login

  end

  def login_user login

    @driver.navigate.to @url
    @driver.find_element(:class, 'login').click
    @driver.find_element(:id, 'username').send_keys login
    @driver.find_element(:id, 'password').send_keys 'qwerty'
    @driver.find_element(:name, 'login').click

  end

  def logout_user
    @driver.navigate.to @url
    logoutButtons = @driver.find_elements(:class, 'logout')
    if (logoutButtons.empty?)
    else
      logoutButtons.first.click
    end
  end

  def create_new_proj
    projectName = ('name'+ rand(9999).to_s)
    @driver.find_element(:class, 'projects').click
    @driver.find_element(:class, 'icon-add').click
    @driver.find_element(:id, 'project_name').send_keys projectName
    @driver.find_element(:id, 'project_description').send_keys '1234'
    @driver.find_element(:id, 'project_identifier').send_keys projectName
    @driver.find_element(:name, 'commit').click
    return projectName
  end


end