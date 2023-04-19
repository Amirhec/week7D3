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
    after_initialize :ensure_session_token
    validates :username, :password, presence: true
    validates :password_digest, :session_token, presence: true 
    validates :session_token, uniqueness: {case_sensitive: true }
    validates :password, length: {minimum: 6}, allow_nil: true



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

    def ensure_session_token
        self.session_token ||= generate_session_token
    end


    
end
