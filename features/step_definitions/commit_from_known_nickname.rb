Given(/^an user "(.*?)"$/) do |arg1|
  create(:user, nickname: arg1, email: "#{arg1}@example.com")
end

Given(/^the email of "(.*?)" is "(.*?)"$/) do |arg1, arg2|
  User.find_by_nickname!(arg1).update(email: arg2)
end

Then(/^the tip for commit "(.*?)" is for user "(.*?)"$/) do |arg1, arg2|
  expect(Tip.find_by_commit!(arg1).user.nickname).to eq(arg2)
end

Then(/^there should be no user with email "(.*?)"$/) do |arg1|
  expect(User.where(email: arg1).size).to eq(0)
end

