Before '@javascript' do
  # https://github.com/teampoltergeist/poltergeist/issues/754#issuecomment-228433228
  page.driver.clear_memory_cache
end

Given(/^I'm logged in as "(.*?)"$/) do |arg1|
  OmniAuth.config.test_mode = true
  OmniAuth.config.mock_auth[:github] = {
    "info" => {
      "nickname" => arg1,
      "primary_email" => "#{arg1.gsub(/\s+/,'')}@example.com",
      "verified_emails" => [],
    },
  }
  visit root_path
  click_on "Sign in"
  click_on "Sign in with Github"
  expect(page).to have_content("Successfully authenticated")
  OmniAuth.config.mock_auth[:github] = nil
  @current_user = User.find_by(nickname: arg1)
end

Given(/^I'm logged in on GitHub as "(.*?)"$/) do |arg1|
  OmniAuth.config.test_mode = true
  OmniAuth.config.mock_auth[:github] = {
    "info" => {
      "nickname" => arg1,
      "primary_email" => "#{arg1.gsub(/\s+/,'')}@example.com",
      "verified_emails" => [],
    },
  }
end

Given(/^I'm not logged in$/) do
  visit root_path
  if page.has_content?("Sign Out")
    click_on "Sign Out"
    expect(page).to have_content("Signed out successfully")
  else
    expect(page).to have_content("Sign in")
  end
end

When(/^I log out$/) do
  click_on "Sign Out"
  expect(page).to have_content "Signed out successfully"
end

When(/^I log in as "(.*?)"$/) do |arg1|
  step "I'm logged in as \"#{arg1}\""
end


When(/^I visit the home page$/) do
  visit '/'
end

When(/^I fill "(.*?)" with "(.*?)"$/) do |arg1, arg2|
  fill_in arg1, with: arg2
end

Given(/^I go to the project page$/) do
  visit project_path(@project)
end

Given(/^I click on "(.*?)"$/) do |arg1|
  click_on(arg1)
end

Given(/^I click on "(.*?)" in the sign in form$/) do |arg1|
  within "#sign-in-form" do
    click_on(arg1)
  end
end

Given(/^I check "(.*?)"$/) do |arg1|
  check(arg1)
end

Given(/^I uncheck "(.*?)"$/) do |arg1|
  uncheck(arg1)
end

Then(/^I should see "(.*?)"$/) do |arg1|
  expect(page).to have_content(arg1)
end

Then(/^I should not see "(.*?)"$/) do |arg1|
  expect(page).to have_no_content(arg1)
end

Then(/^I should not see the button "(.*?)"$/) do |arg1|
  expect(page).to have_no_button(arg1)
end

Given(/^I fill "(.*?)" with:$/) do |arg1, string|
  fill_in arg1, with: string
end

When(/^I visit the project page$/) do
  visit project_path(@project)
end

Then(/^I should see the project donation address$/) do
  address = @project.bitcoin_address
  expect(address).not_to be_blank
  expect(page).to have_content(address)
end

Then(/^I should see the project balance is "(.*?)"$/) do |arg1|
  expect(page).to have_content("Funds #{arg1}")
end

Then(/^I should see a link "(.*?)" to "(.*?)"$/) do |arg1, arg2|
  link = find("a", text: arg1)
  expect(link["href"]).to eq(arg2)
end

Then(/^I should not see a link "(.*?)" to "(.*?)"$/) do |arg1, arg2|
  link = all("a", text: arg1).first
  expect((link.nil? or link["href"] != arg2)).to be true
end

Then(/^I should not see the image "(.*?)"$/) do |arg1|
  find("img[src=\"#{arg1}\"]")
end

When(/^I click on the "(.*?)" link in the email$/) do |arg1|
  begin
    link = Nokogiri::HTML.parse(@email.body.decoded).css("a").detect { |el| el.text == arg1 }
    expect(link).not_to be_nil
  rescue
    puts @email.body
    raise
  end
  url = URI.parse(link["href"]).request_uri
  visit url
end

When(/^I click on "(.*?)" in the email$/) do |arg1|
  step "I click on the \"#{arg1}\" link in the email"
end

Then(/^the user with email "(.*?)" should have his email confirmed$/) do |arg1|
  expect(User.find_by(email: arg1).confirmed?).to be true
end

When(/^I go to edit my profile$/) do
  find(".edit-profile-link").click
end
