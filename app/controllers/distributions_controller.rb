class DistributionsController < ApplicationController
  load_and_authorize_resource :project
  load_and_authorize_resource :distribution, :through => :project

  def index
    @distributions = @distributions.order(created_at: :desc).page(params[:page]).per(30)
  end

  def new
  end

  def create
    @distribution.project = @project
    finalize_distribution
    if @distribution.save
      redirect_to [@project, @distribution], notice: "Distribution created"
    else
      render "new"
    end
  end

  def edit
  end

  def update
    @distribution.attributes = distribution_params
    finalize_distribution
    if @distribution.save
      redirect_to [@project, @distribution], notice: "Distribution updated"
    else
      render "edit"
    end
  end

  def show
    commontator_thread_show(@distribution)
  end

  def send_transaction
    @distribution.send_transaction!
    redirect_to [@project, @distribution], flash: {notice: "Transaction sent"}
  rescue RuntimeError => e
    redirect_to [@project, @distribution], flash: {error: e.message}
  end

  def new_recipient_form
    @tips = []
    if params[:user] and params[:user][:nickname].present?
      user = User.enabled.where(nickname: params[:user][:nickname]).first_or_initialize
      if user.new_record?
        raise "Invalid GitHub user" unless user.valid_github_user?
        user.confirm!
        user.save!
      end
      @tips << Tip.new(user: user)
    elsif params[:user] and params[:user][:identifier].present?
      user = User.enabled.find_by(identifier: params[:user][:identifier])
      @tips << Tip.new(user: user)
    elsif params[:not_rewarded_commits]
      @project.commits.each do |commit|
        next if Tip.where(reason: commit).any?
        next if Tip.where(commit: commit.sha).where.not(amount: nil).any?
        tip = Tip.build_from_commit(commit)
        @tips << tip if tip
      end
    elsif params[:commit] and sha = params[:commit][:sha]
      commits = @project.commits.where("sha LIKE ?", "#{sha}%")
      count = commits.count
      raise "Commit not found" if count == 0
      raise "Multiple commits match this prefix" if count > 1
      commit = commits.first
      @tips << Tip.build_from_commit(commit)
    else
      raise "Unrecognized recipient"
    end
    result = render_to_string(layout: false)
    render json: {result: result}
  rescue RuntimeError => e
    render json: {error: e.message}
  end

  private

  def distribution_params
    if params[:distribution]
      params.require(:distribution).permit(tips_attributes: [:id, :coin_amount, :user_id, :comment, :reason_type, :reason_id, :_destroy])
    else
      {}
    end
  end

  def finalize_distribution
    @distribution.tips.each do |tip|
      tip.project = @project
      if tip.user.new_record?
        tip.user.skip_confirmation_notification!
      end
    end
  end
end
