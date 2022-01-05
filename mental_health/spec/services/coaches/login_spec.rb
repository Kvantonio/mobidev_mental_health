require 'rails_helper'

RSpec.describe Coaches::LoginService do
    it 'check if coach successfully login' do
      coach = create(:coach)
      Coaches::LoginService.call({ email: coach.email, password: coach.password })
    end
    it 'check coach email error' do
      coach = create(:coach)
      expect do
        Coaches::LoginService.call({ email: '', password: coach.password })
      end.to raise_error ServiceError, 'Password or email is invalid'
    end
    it 'check coach password error' do
      coach = create(:coach)
      expect do
        Coaches::LoginService.call({ email: coach.email, password: '' })
      end.to raise_error ServiceError, 'Password or email is invalid'
    end
end
