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
    createdLogin = register_user
    logout_user
    login_user createdLogin

    expected_text = "My account"
    actual_text = @driver.find_element(:class, 'my-account').text
    assert_equal(expected_text, actual_text)
  end

  def test_create_proj
    createdLogin = register_user
    createdProject = create_new_proj
    expected_text = "Successful creation."
    actual_text = @driver.find_element(:id, 'flash_notice').text
    assert_equal(expected_text, actual_text)

  end

  def test_create_project_version
    createdLogin = register_user
    createdProject = create_new_proj

    numberVersionsBefore = @driver.find_elements(:class, 'version').length
    create_project_version 'version1'
    sleep 3
    numberVersionsAfter = @driver.find_elements(:class, 'version').length
    assert_equal(numberVersionsBefore + 1, numberVersionsAfter)


  end

  def test_create_issues
    createdLogin = register_user
    createdProject = create_new_proj
    @driver.find_element(:class, 'issues').click
    numberIssuesBefore = @driver.find_elements(:class, 'issue').length

    create_issue 'bug', 'subject1'
    create_issue 'feature', 'subject2'
    create_issue 'support', 'subject3'

    @driver.find_element(:class, 'issues').click
    numberIssuesAfter = @driver.find_elements(:class, 'issue').length
    assert_equal(numberIssuesBefore + 3, numberIssuesAfter)


  end

  def test_add_user_to_project
    createdLogin1 = register_user
    logout_user
    createdLogin2 = register_user
    createdProject = create_new_proj
    numbersActiveUsersBefore = @driver.find_elements(:class, 'active').length
    add_user_to_project createdLogin1
    sleep 3
    numbersActiveUsersAfter = @driver.find_elements(:class, 'active').length
    assert_equal(numbersActiveUsersBefore + 1, numbersActiveUsersAfter)
  end

  def test_positive_logout
    createdLogin = register_user
    logout_user

    expected_text = "Sign in"
    actual_text = @driver.find_element(:class, 'login').text
    assert_equal(expected_text, actual_text)
  end


  def test_change_password
    createdLogin = register_user
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

  def create_project_version versionName
    @driver.find_element(:id, 'tab-versions').click
    sleep 2
    @driver.find_elements(:class, 'icon-add')[1].click
    sleep 5
    @driver.find_element(:id, 'version_name').send_keys versionName
    @driver.find_element(:name, 'commit').click
  end

  def create_issue issueTypeName, subject
    @driver.find_element(:class, 'new-issue').click
    sleep 2
    @driver.find_element(:id, 'issue_tracker_id').click
    @driver.find_element(:id, 'issue_tracker_id').send_keys [issueTypeName[0], :enter]
    sleep 2
    @driver.find_element(:id, 'issue_subject').send_keys subject
    @driver.find_element(:name, 'commit').click
  end


  def change_password oldPassword, newPassword

    @driver.find_element(:class, 'my-account').click
    @driver.find_element(:class, 'icon-passwd').click
    @driver.find_element(:id, 'password').send_keys oldPassword
    @driver.find_element(:id, 'new_password').send_keys newPassword
    @driver.find_element(:id, 'new_password_confirmation').send_keys newPassword
    @driver.find_element(:name, 'commit').click

  end


  def add_user_to_project userName

    @driver.find_element(:id, 'tab-members').click
    @driver.find_element(:class, 'icon-add').click
    sleep 5
    @driver.find_element(:id, 'principal_search').send_keys userName
    sleep 5
    usersList = @driver.find_elements(:name, 'membership[user_ids][]')
    assert usersList.length==1
    usersList.first.click
    rolesList = @driver.find_elements(:name, 'membership[role_ids][]')
    rolesList[4].click
    @driver.find_element(:id, 'member-add-submit').click

  end

end