class UserController < ApplicationController
  before_action :check_user_login!, :set_user

  def dashboard
    @invitation = @user.invitation
    @notifications = @user.notifications.where(coach_id: nil).order('created_at DESC')
    @problems = @user.problems
  end

  def techniques
    @recommendations = @user.recommendations
    @invitation = @user.invitation
  end

  def edit
    @problems = Problem.all
  end

  def update
    if @user.update(user_update_params)
      params[:user][:problems]&.each do |problem|
        problem_object = Problem.find_by_title(problem)
        @user.problems << problem_object unless @user.problems.include?(problem_object)
      end
      @user.notifications.create(description: 'You changed your profile settings', status: 1)
      redirect_to user_dashboard_path
    else
      render :edit
    end
  end

  def edit_password
  end

  def update_password
    if BCrypt::Password.new(@user.password_digest) == params[:user][:old_password]
      if @user.update(user_update_password_params)
        @user.notifications.create(description: 'You changed your password settings', status: 1)
        redirect_to user_dashboard_path
      else
        render :edit_password
      end
    else
      render :edit_password
    end
  end

  def coaches_page
    @invitation = @user.invitation
    @problems = Problem.all
    coaches = Coach.all
    if params[:filter].present?
      coaches_expertise = filter_by_expertise(params[:filter][:problems], coaches)
      coaches_users = filter_by_users_count(params[:filter][:users], coaches_expertise)
      coaches_gender = filter_by_gender(params[:filter][:gender], coaches_users)
      @coaches = filter_by_age(params[:filter][:age], coaches_gender)
    else
      @coaches = coaches
    end

  end

  private

  def set_user
    @user = User.find_by_id(session[:user_id])
  end

  def user_update_params
    params.require(:user).permit(:name, :email, :user_avatar, :about, :age, :gender)
  end

  def user_update_password_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  def filter_by_expertise(params, coaches)
    params ? Problem.find_by(title: params).coaches : coaches
  end

  def filter_by_gender(params, coaches)
    params.nil? || params.include?(' ') ? coaches : coaches.where(gender: params)
  end

  def filter_by_age(params, coaches)
    params.nil? || params.include?(' ') ? coaches : coaches.where(params)
  end

  def filter_by_users_count(params, coaches)
    return coaches if params.nil?

    array = []
    params.each do |user_total|
      array +=  Coach.select(:id).joins(:invitations).where("invitations.status IS true").having("COUNT(invitations.id) <= 5").group("coaches.id").ids if (user_total == '5')
      array += Coach.select(:id).joins(:invitations).where("invitations.status IS true").having("COUNT(invitations.id) > 5 and COUNT(invitations.id) <= 10").group("coaches.id").ids if (user_total == '5-10')
      array += Coach.select(:id).joins(:invitations).where("invitations.status IS true").having("COUNT(invitations.id) > 10 and COUNT(invitations.id) <= 20").group("coaches.id").ids if (user_total == '10-20')
      array += Coach.select(:id).joins(:invitations).where("invitations.status IS true").having("COUNT(invitations.id) > 20").group("coaches.id").ids if (user_total == '20')
    end
    array.uniq!
    coaches.where(id: array)
  end
end
