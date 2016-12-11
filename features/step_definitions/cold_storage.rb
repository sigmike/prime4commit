Given(/^the cold storage addresses are$/) do |table|
  CONFIG["cold_storage"] ||= {}
  CONFIG["cold_storage"]["addresses"] = table.raw.map(&:first)
end

Given(/^the project address is "(.*?)"$/) do |arg1|
  @project.update(bitcoin_address: arg1)
end

Given(/^the project cold storage withdrawal address is "(.*?)"$/) do |arg1|
  @project.update(cold_storage_withdrawal_address: arg1)
end

When(/^there's a new incoming transaction of "([^"]*?)" on the project account$/) do |arg1|
  BitcoinDaemon.instance.add_transaction(account: @project.address_label, amount: arg1.to_d, address: @project.bitcoin_address)
end

When(/^there's a new incoming transaction of "(.*?)" to address "(.*?)" on the project account$/) do |arg1, arg2|
  BitcoinDaemon.instance.add_transaction(account: @project.address_label, amount: arg1.to_d, address: arg2)
end

When(/^there's a new incoming transaction of "(.*?)" to address "(.*?)" on the project account with (\d+) confirmations$/) do |arg1, arg2, arg3|
  BitcoinDaemon.instance.add_transaction(account: @project.address_label, amount: arg1.to_d, address: arg2, confirmations: arg3.to_i)
end

When(/^there's a new outgoing transaction of "(.*?)" to address "(.*?)" on the project account$/) do |arg1, arg2|
  BitcoinDaemon.instance.add_transaction(category: "send", account: @project.address_label, amount: -arg1.to_d, address: arg2)
end

When(/^there's a new outgoing transaction of "(.*?)" to address "(.*?)" on the project account with (\d+) confirmations$/) do |arg1, arg2, arg3|
  BitcoinDaemon.instance.add_transaction(category: "send", account: @project.address_label, amount: -arg1.to_d, address: arg2, confirmations: arg3.to_i)
end

When(/^the project balance is updated$/) do
  BalanceUpdater.work
end

Then(/^updating the project balance should raise an error$/) do
  expect { BalanceUpdater.work }.to raise_error(RuntimeError)
end

Then(/^the project balance should be "(.*?)"$/) do |arg1|
  expect(@project.reload.available_amount.to_d / COIN).to eq(arg1.to_d)
end

Then(/^the project amount in cold storage should be "(.*?)"$/) do |arg1|
  expect(@project.reload.cold_storage_amount / COIN).to eq(arg1.to_d)
end

When(/^"(.*?)" coins of the project funds are sent to cold storage$/) do |arg1|
  @project.send_to_cold_storage!((arg1.to_d * COIN).to_i)
end

Then(/^there should be an outgoing transaction of "(.*?)" to address "(.*?)" on the project account$/) do |arg1, arg2|
  transactions = BitcoinDaemon.instance.list_transactions(@project.address_label)
  expect(transactions.map { |t| t["category"] }).to eq(["send"])
  expect(transactions.map { |t| t["address"] }).to eq([arg2])
  expect(transactions.map { |t| -t["amount"].to_d / COIN }).to eq([arg1.to_d])
end

Given(/^the project has no cold storage withdrawal address$/) do
  @project.update(cold_storage_withdrawal_address: nil)
end

Then(/^the project should have a cold storage withdrawal address$/) do
  expect(@project.reload.cold_storage_withdrawal_address).not_to be_blank
end

Then(/^the project cold storage withdrawal address should be linked to its account$/) do
  expect(BitcoinDaemon.instance.get_addresses_by_account(@project.address_label)).to include(@project.reload.cold_storage_withdrawal_address)
end
