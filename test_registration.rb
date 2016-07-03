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


  def test_positive_registration
    register_user
    expected_text = "Your account has been activated. You can now log in."
    actual_text = @driver.find_element(:id, 'flash_notice').text

    #sleep 300
    assert_equal(expected_text, actual_text)
  end


  def test_positive_login
    created_login = register_user
    logout_user
    login_user created_login

    expected_text = "My account"
    actual_text = @driver.find_element(:class, 'my-account').text
    assert_equal(expected_text, actual_text)
  end

  def test_create_proj
    register_user
    create_new_proj
    expected_text = "Successful creation."
    actual_text = @driver.find_element(:id, 'flash_notice').text
    assert_equal(expected_text, actual_text)

  end

  def test_create_project_version
    register_user
    create_new_proj

    number_versions_before = @driver.find_elements(:class, 'version').length
    create_project_version 'version1'
    sleep 3
    number_versions_after = @driver.find_elements(:class, 'version').length
    assert_equal(number_versions_before + 1, number_versions_after)


  end

  def test_create_issues
    register_user
    create_new_proj
    @driver.find_element(:class, 'issues').click
    number_issues_before = @driver.find_elements(:class, 'issue').length

    create_issue 'bug', 'subject1'
    create_issue 'feature', 'subject2'
    create_issue 'support', 'subject3'

    @driver.find_element(:class, 'issues').click
    number_issues_after = @driver.find_elements(:class, 'issue').length
    assert_equal(number_issues_before + 3, number_issues_after)


  end

  def test_add_user_to_project
    created_login = register_user
    logout_user
    register_user
    create_new_proj
    numbers_active_users_before = @driver.find_elements(:class, 'active').length
    add_user_to_project created_login
    sleep 3
    numbers_active_users_after = @driver.find_elements(:class, 'active').length
    assert_equal(numbers_active_users_before + 1, numbers_active_users_after)
  end

  def test_positive_logout
    register_user
    logout_user

    expected_text = "Sign in"
    actual_text = @driver.find_element(:class, 'login').text
    assert_equal(expected_text, actual_text)
  end


  def test_change_password
    register_user
    change_password 'qwerty', 'qwerty1'
    expected_text = "Password was successfully updated."
    actual_text = @driver.find_element(:id, 'flash_notice').text
    assert_equal(expected_text, actual_text)

  end

  ######### Helpers

  def register_user
    @driver.navigate.to @url
    @driver.find_element(:class, 'register').click

    login = ('login'+ rand(9999).to_s)

    @driver.find_element(:id, 'user_login').send_keys login
    @driver.find_element(:id, 'user_password').send_keys 'qwerty'
    @driver.find_element(:id, 'user_password_confirmation').send_keys 'qwerty'
    @driver.find_element(:id, 'user_firstname').send_keys login
    @driver.find_element(:id, 'user_lastname').send_keys 'last name'
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
    logout_buttons = @driver.find_elements(:class, 'logout')
    if logout_buttons.empty?
    else
      logout_buttons.first.click
    end
  end

  def create_new_proj
    project_name = ('name'+ rand(9999).to_s)
    @driver.find_element(:class, 'projects').click
    @driver.find_element(:class, 'icon-add').click
    @driver.find_element(:id, 'project_name').send_keys project_name
    @driver.find_element(:id, 'project_description').send_keys '1234'
    @driver.find_element(:id, 'project_identifier').send_keys project_name
    @driver.find_element(:name, 'commit').click
    return project_name
  end

  def create_project_version (version_name)
    @driver.find_element(:id, 'tab-versions').click
    sleep 2
    @driver.find_elements(:class, 'icon-add')[1].click
    sleep 5
    @driver.find_element(:id, 'version_name').send_keys version_name
    @driver.find_element(:name, 'commit').click
  end

  def create_issue (issue_type_name, subject)
    @driver.find_element(:class, 'new-issue').click
    sleep 2
    @driver.find_element(:id, 'issue_tracker_id').click
    @driver.find_element(:id, 'issue_tracker_id').send_keys [issue_type_name[0], :enter]
    sleep 2
    @driver.find_element(:id, 'issue_subject').send_keys subject
    @driver.find_element(:name, 'commit').click
  end


  def change_password (old_password, new_password)

    @driver.find_element(:class, 'my-account').click
    @driver.find_element(:class, 'icon-passwd').click
    @driver.find_element(:id, 'password').send_keys old_password
    @driver.find_element(:id, 'new_password').send_keys new_password
    @driver.find_element(:id, 'new_password_confirmation').send_keys new_password
    @driver.find_element(:name, 'commit').click

  end


  def add_user_to_project (user_name)

    @driver.find_element(:id, 'tab-members').click
    @driver.find_element(:class, 'icon-add').click
    sleep 5
    @driver.find_element(:id, 'principal_search').send_keys user_name
    sleep 5
    users_list = @driver.find_elements(:name, 'membership[user_ids][]')
    assert users_list.length==1
    users_list.first.click
    roles_list = @driver.find_elements(:name, 'membership[role_ids][]')
    roles_list[4].click
    @driver.find_element(:id, 'member-add-submit').click

  end

end