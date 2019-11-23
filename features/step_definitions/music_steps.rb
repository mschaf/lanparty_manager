When /I fill in the music search field with "(.+)"/ do |text|
  field = page.find('.music--search').find('input[type=text]')
  field.fill_in(with: text)
end
