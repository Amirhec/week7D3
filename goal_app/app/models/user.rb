# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  username        :string           not null
#  password_digest :string           not null
#  session_token   :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class User < ApplicationRecord
    validates :username, :password, presence: true


    attr_reader :password

    def password=(password)
        self.password_digest = BCrypt::Password.create(password)
        @password = password
    end

    def generate_session_token
        SecureRandom::urlsafe_base64
    end

    def self.find_by_credentials(username, password)
        user = User.find_by(username: username)

        if user && is_password?(password)
            user
        else
            nil
        end
    end

    # def 
end
