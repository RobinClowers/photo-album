class Photos::PlusOnesController < ApplicationController
  before_action :require_signed_in, except: :index

  def create
    if plus_one.save
      render json: { ok: true }, status: :created
    else
      render json: { errors: ["Something went wrong"] }, status: :unprocessable_entity
    end
  end

  def destroy
    if plus_one.destroy
      render json: { ok: true }, status: :ok
    else
      render json: { errors: ["Something went wrong"] }, status: :unprocessable_entity
    end
  end

  private

  def plus_one
    PlusOne.find_or_create_by({ photo_id: params[:photo_id], user_id: current_user.id })
  end
end
