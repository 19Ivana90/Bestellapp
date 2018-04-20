class UsersController < ApplicationController
  before_action :require_admin

  def index
    @users = User.by_reverse_full_name
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to :users, notice: 'Benutzer erfolgreich angelegt.'
    else
      flash.now[:alert] = 'Benutzer konnte nicht angelegt werden.'
      render :new
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])

    if @user.update(user_params)
      redirect_to :users, notice: 'Benutzer erfolgreich geändert.'
    else
      flash.now[:alert] = 'Benutzer konnte nicht geändert werden.'
      render :edit
    end
  end

private

  def user_params
    params.fetch(:user, {}).permit(:first_name, :last_name, :email, :role)
  end

end
