Then /^I wait for active ajax requests to finish$/ do
  patiently do
    expect(page.evaluate_script('up.proxy.isBusy()')).to eq false
  end
end
