Given(/^a project "([^"]*)" with a donation address "([^"]*)" associated with "([^"]*)"$/) do |arg1, arg2, arg3|
  @project = Project.create!(
    name: arg1,
    full_name: "example/#{arg1}",
    bitcoin_address: 'mq4NtnmQoQoPfNWEPbhSvxvncgtGo6L8WY',
    hold_tips: false,
    address_label: "project-#{arg1}",
  )
  step %Q[the project has a donation address "#{arg2}" associated with "#{arg3}"]
end


Then(/^I should see the project donation address associated with "(.*?)"$/) do |arg1|
  address = @project.donation_addresses.find_by(sender_address: arg1).donation_address
  expect(address).not_to be_blank
  expect(page).to have_content(address)
end

Given(/^there's a new incoming transaction of "(.*?)" to the donation address associated with "(.*?)"$/) do |arg1, arg2|
  address = @project.donation_addresses.find_by(sender_address: arg2).donation_address
  expect(address).not_to be_blank
  BitcoinDaemon.instance.add_transaction(account: @project.address_label, amount: arg1.to_d, address: address)
end

Given(/^there's a new incoming transaction of "([^"]*)" to "([^"]*)" in transaction "([^"]*)"$/) do |arg1, arg2, arg3|
  donation_address = DonationAddress.find_by!(donation_address: arg2)
  project = donation_address.project
  BitcoinDaemon.instance.add_transaction(
    account: project.address_label,
    amount: arg1.to_d,
    address: donation_address.donation_address,
    txid: arg3,
  )
end

Then(/^I should see the donor "(.*?)" sent "(.*?)"$/) do |arg1, arg2|
  within ".donor-row", text: arg1 do
    expect(find(".amount").text.to_d).to eq(arg2.to_d)
  end
end

Given(/^the project has a donation address "(.*?)" associated with "(.*?)"$/) do |arg1, arg2|
  @project.donation_addresses.create!(sender_address: arg2, donation_address: arg1)
end

When(/^there's a new incoming transaction of "([^"]*?)" to the project donation address$/) do |arg1|
  BitcoinDaemon.instance.add_transaction(account: @project.address_label, amount: arg1.to_d, address: @project.bitcoin_address)
end

