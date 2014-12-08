class Photos::PlusOnesController < ApplicationController
  before_filter :require_signed_in, except: :index
  layout false

  expose(:plus_one) { PlusOneForm.new(params.merge(current_user: current_user, router: self)) }

  def index
  end

  def create
    plus_one.save
    render 'index', status: :created
  end

  def destroy
    plus_one.destroy
    render 'index', status: :ok
  end
end
