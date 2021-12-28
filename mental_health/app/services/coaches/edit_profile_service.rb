module Coaches
  class EditProfileService < ApplicationService
    def initialize(coach, params)
      @coach = coach
      @params = params
    end

    def call
      coach_edit
      add_problems
      add_diplomas
      add_experiences
      add_certificates
      add_social_networks
    end

    private

    def add_problems
      @params[:coach][:problems]&.each do |problem|
        problem_object = Problem.find_by_title(problem)
        @coach.problems << problem_object unless @coach.problems.include?(problem_object)
      end
    end

    def add_diplomas
      @params[:coach][:educations]&.each do |education|
        @coach.diplomas << Diploma.create(title: education) if education != ''
      end
    end

    def add_experiences
      @params[:coach][:experiences]&.each do |experience|
        @coach.experiences << Experience.create(title: experience) if experience != ''
      end
    end

    def add_certificates
      @params[:coach][:certificates]&.each do |certificate|
        @coach.certificates << Certificate.create(title: certificate) if certificate != ''
      end
    end

    def add_social_networks
      @params[:coach][:networks]&.each do |network|
        @coach.social_networks << SocialNetwork.create(title: network) if network != ''
      end
    end

    def coach_edit
      raise ServiceError, 'Profile update error' unless @coach.update(coach_update_params)
    end

    def coach_update_params
      @params.require(:coach).permit(:name, :email, :coach_avatar, :about, :age, :gender)
    end
  end
end

