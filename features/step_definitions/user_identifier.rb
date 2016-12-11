Then(/^I should see the identifier of "(.*?)"$/) do |arg1|
  identifier = User.find_by(email: arg1).identifier
  expect(identifier).to be_present
  expect(page).to have_content identifier
end
