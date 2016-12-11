
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

