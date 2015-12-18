class User < ActiveRecord::Base
  has_many :oauth_applications, class_name: 'Doorkeeper::Application', as: :owner
end