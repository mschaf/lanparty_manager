When /^I sign in$/ do
  signin
end

Given /^I am signed in$/ do
  step 'I sign in'
end

When /^I sign in as an admin$/ do
  signin(admin: true)
end

Given /^I am signed in as an admin$/ do
  step 'I sign in as an admin'
end

When /^I click on the first "(.+)" element$/ do |element|
  patiently do
    page.first(element).click
  end
end

When /^I click on the first "(.+)"$/ do |text|
  patiently do
    contains_text = %{contains(., \"#{text}\")}
    # find the innermost selector that matches
    element = page.first(:xpath, ".//*[#{contains_text} and not (./*[#{contains_text}])]")
    element.click
  end
end

Given /^the user above is locked$/ do
  User.last.update(locked: true)
end

def signin(admin: false)
  user = create(:user, password: '123456', admin: admin)
  visit signin_path
  page.fill_in 'Username', with: user.name
  page.fill_in 'Password', with: "123456"
  click_button('Sign In')
  step('I wait for active ajax requests to finish')
end

