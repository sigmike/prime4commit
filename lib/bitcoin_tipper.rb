class BitcoinTipper
  def self.work_forever
    while true do
      self.work
    end
  end

  def self.work
    Rails.logger.info "Traversing projects..."
    Project.enabled.find_each do |project|
      Rails.logger.info " Project #{project.id} #{project.full_name}"
      project.update_commits
      project.tip_commits
    end

    Rails.logger.info "Sending tips to commits..."
    Project.enabled.find_each do |project|
      tips = project.tips_to_pay
      amount = tips.sum(&:amount).to_d
      if amount > CONFIG["min_payout"].to_d * COIN
        distribution = Distribution.new(project_id: project.id)
        unless distribution.save
          raise "Unable to create distribution on project #{project.id}: #{distribution.errors.full_messages.inspect}"
        end
        tips.each do |tip|
          tip.update_attribute :distribution_id, distribution.id
        end
        distribution.reload.send_transaction!
        Rails.logger.info "  #{distribution.inspect}"
      end
    end

    Rails.logger.info "Refunding unclaimed tips..."
    Tip.refund_unclaimed

    Rails.logger.info "Updating projects cache..."
    Project.update_cache

    Rails.logger.info "Updating users cache..."
    User.update_cache
  end

  def self.create_distributions
    Rails.logger.info "Creating distribution"
    ActiveRecord::Base.transaction do
    end   
  end

end
