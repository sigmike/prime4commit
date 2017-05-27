
Given(/^the project does not hold tips$/) do
  @project.update(hold_tips: false)
end

Given(/^the project GitHub name is "(.*?)"$/) do |arg1|
  @project.update(full_name: arg1)
end

Given(/^the commits on GitHub for project "(.*?)" are$/) do |arg1, table|
  @project.reload
  expect(@project.full_name).to eq(arg1)
  commits = []
  table.hashes.each do |row|
    commit = OpenStruct.new(
      sha: row["sha"],
      author: OpenStruct.new(
        login: row["author"],
      ),
      commit: OpenStruct.new(
        message: row["message"] || "Some changes",
        author: OpenStruct.new(
          email: row["email"] || "author@example.com",
        ),
        committer: OpenStruct.new(
          date: Time.now,
        ),
      ),
    )
    commits << commit
  end
    
  expect(@project).to receive(:get_commits).and_return(commits)
end

When(/^the project tips are built from commits$/) do
  @project.tip_commits
end

Then(/^the project should have these tips:$/) do |table|
  tips = @project.tips.map do |tip|
    {
      commit: tip.commit,
      amount: tip.amount ? (tip.amount.to_f / COIN).to_s : "",
    }.with_indifferent_access
  end
  expect(tips).to eq(table.hashes)
end
