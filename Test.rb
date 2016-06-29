require 'selenium-webdriver'
driver = Selenium::WebDriver.for :firefox
driver.navigate.to 'http://www.redmine.org'
driver.find_element(:class, 'register').click
driver.find_element(:id, 'user_login').send_keys 'tyuoo'
driver.find_element(:id, 'user_password').send_keys 'qwerty'
driver.find_element(:id, 'user_password_confirmation').send_keys 'qwerty'
driver.find_element(:id, 'user_firstname').send_keys 'poiopl'
driver.find_element(:id, 'user_lastname').send_keys 'hjhkjl'
driver.find_element(:id, 'user_mail').send_keys 'hdu@klkl.com'
driver.find_element(:name, 'commit').click
sleep 5




