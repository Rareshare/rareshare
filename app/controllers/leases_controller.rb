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
    lp = params[:lease]

    @lease = Lease.new.tap do |l|
      l.lessor_id    = lp[:lessor_id]
      l.lessee_id    = lp[:lessee_id]
      l.tool_id      = lp[:tool_id]
      l.started_at   = lp[:started_at]
      l.ended_at     = lp[:ended_at]
      l.tos_accepted = lp[:tos_accepted]
    end

    @tool = @lease.tool

    if @lease.valid?
      redirect_to dashboard_path, flash: { notice: "Lease successful!" }
    else
      render 'leases/new'
    end
  end
end