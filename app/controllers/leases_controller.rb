class LeasesController < ApplicationController
  before_filter :authenticate_user!

  def new
    add_breadcrumb "New Lease", new_lease_path(params)
    @tool = Tool.find(params[:tool_id])

    @lease = Lease.new.tap do |l|
      l.lessor_id  = @tool.owner_id
      l.lessee_id  = current_user.id
      l.tool_id    = @tool.id
      l.started_at = params[:date]
      l.ended_at   = params[:date]
    end

  end

  def create
    add_breadcrumb "New Lease", new_lease_path(params)

    @lease = current_user.reserve(params[:lease])
    @tool = @lease.tool

    if @lease.valid?
      @lease.save!
      redirect_to dashboard_path, flash: { notice: "Lease successful!" }
    else
      render 'leases/new'
    end
  end

  def destroy
    @lease = Lease.find(params[:id])

    if @lease.reserved_by?(current_user)
      @lease.cancel!
      redirect_to dashboard_path, flash: { notice: "Lease successfully cancelled." }
    else
      redirect_to dashboard_path, flash: { error: "You do not have permission to cancel this lease." }
    end
  end
end