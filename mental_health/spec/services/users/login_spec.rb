require 'rails_helper'

RSpec.describe Users::LoginService do
    it 'check if user successfully login' do
      user = create(:user)
      Users::LoginService.call({ email: user.email, password: user.password })
    end
    it 'check user email error' do
      user = create(:user)
      expect do
        Users::LoginService.call({ email: '', password: user.password })
      end.to raise_error ServiceError, 'Password or email is invalid'
    end

    it 'check user password error' do
      user = create(:user)
      expect do
        Users::LoginService.call({ email: user.email, password: '' })
      end.to raise_error ServiceError, 'Password or email is invalid'
    end
end
