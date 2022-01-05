class InvitationController < ApplicationController
  before_action :set_user, :set_coach

  def modal_send_invitation
    @coach = Coach.find_by_id(params[:coach_id])
    @invitation = @user.invitation
    respond_to do |format|
      format.html
      format.js
    end
  end

  def send_invitation
    @coach = Coach.find_by_id(params[:coach_id]) if params[:coach_id]
    if @coach && @user.invitation.nil?
      Invitation.create(coach_id: @coach.id, user_id: @user.id, status: false)
      @user.notifications.create(description: "You have sent an invitation to coach #{@coach.name}", status: 1)
      @coach.notifications.create(description: "You have received an invitation to become a coach from a user #{@user.name}", user_id: @user.id, status: 1)
    end
    redirect_to user_dashboard_path
  end

  def modal_cancel_invitation
    @coach = @user.invitation.coach if @user

    respond_to do |format|
      format.html
      format.js
    end
  end

  def cancel_invitation
    if @user
      @user.notifications.create(description: "You have canceled an invitation to coach #{@user.invitation.coach.name}",
                                      coach_id: @user.invitation.coach.id, status: 1)
      @user.invitation&.destroy
    end
    redirect_to user_dashboard_path
  end

  def confirm_user
    invitation = Invitation.find_by_id(params[:invitation_id])
    if invitation
      invitation.user.notifications.create(
        description: "Coach #{invitation.coach.name} agreed to become your coach",
        status: 1
      )
      invitation.coach.notifications.create(
        description: "You agreed to become a coach for a user #{invitation.user.name}",
        user_id: invitation.user.id, status: 1
      )
      invitation.update(status: 1)
    end
    redirect_to coach_users_page_path
  end

  def refuse_user
    invitation = Invitation.find_by_id(params[:invitation_id])
    if invitation
      invitation.user.notifications.create(
        description: "Coach #{invitation.coach.name} refused to become your coach",
        status: 1
      )
      invitation.coach.notifications.create(
        description: "You have rejected #{invitation.user.name} invite",
        user_id: invitation.user.id, status: 1
      )
      invitation.destroy
    end
    redirect_to coach_users_page_path
  end

  def modal_end_cooperation
    @coach = @user.invitation.coach if @user
    respond_to do |format|
      format.html
      format.js
    end
  end

  def end_cooperation
    if @user
      @user.notifications.create(description: "You have ended cooperation with coach #{@user.invitation.coach.name}",
                                 status: 1)
      @user.invitation&.destroy
    end
    redirect_to user_dashboard_path
  end

  private

  def set_user
    @user = User.find_by_id(session[:user_id]) if session[:user_id]
  end

  def set_coach
    @coach = Coach.find_by_id(session[:coach_id]) if session[:coach_id]
  end

end
