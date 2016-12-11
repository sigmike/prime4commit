
Then(/^there should be a project "(.*?)"$/) do |arg1|
  expect(Project.pluck(:name)).to include(arg1)
  @project = Project.where(name: arg1).first
end

Then(/^the description of the project should be$/) do |string|
  expect(@project.description).to eq(string)
end

Then(/^I should be on the project page$/) do
  expect(current_url).to eq(project_url(@project))
end

Then(/^there should be no project$/) do
  expect(Project.all).to be_empty
end

Then(/^the GitHub name of the project should be "(.*?)"$/) do |arg1|
  expect(@project.full_name).to eq(arg1)
end

Then(/^the project single collaborators should be "(.*?)"$/) do |arg1|
  if arg1 =~ /@/
    expect(@project.collaborators.map(&:user).map(&:email)).to eq([arg1])
  else
    expect(@project.collaborators.map(&:user).map(&:nickname)).to eq([arg1])
  end
end

Then(/^the project address label should be "(.*?)"$/) do |arg1|
  expect(@project.address_label).to eq(arg1)
end

Then(/^the project donation address should be the same as account "(.*?)"$/) do |arg1|
  expect(@project.bitcoin_address).to eq(BitcoinDaemon.instance.get_addresses_by_account(arg1).first)
end

