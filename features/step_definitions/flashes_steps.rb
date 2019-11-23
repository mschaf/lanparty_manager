Then /^I should see a (\w+) flash$/ do |type|
  expect(page).to have_css(".flash.-#{type}")
end
