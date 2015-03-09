require 'bcrypt'

class User
  include DataMapper::Resource

  attr_reader :password
  attr_accessor :password_confirmation


  validates_confirmation_of :password

  property :id, Serial
  property :email, String, unique: true, message: "This email is already taken"
  property :password_digest, Text


  def password=(password)
  	@password = password
    self.password_digest=BCrypt::Password.create(password)
  end

  def self.authenticate(email, password)
  	user = first(email: email)
  	if user && BCrypt::Password.new(user.password_digest) == password
  		user
  	else
  		nil
  	end
  end

  def self.send_password_recovery_email(email)
    key = ENV['MAILGUN_API_KEY']
    domain = "app33255046.mailgun.org"
    url = "https://api:#{key}@api.mailgun.net/v2/#{domain}"

    RestClient.post url + "/messages",
    :from => "postmaster@" + domain,
    :to => email,
    :subject => "Password Recovery",
    :text => '/users/reset_password/' + "password_token",
    :html => 'Hello'
  end

  private 
  
  def create_token(email)
    user = User.first(:email => email)
    user.password_token = (1..64).map{('A'..'Z').to_a.sample}.join
    user.password_token_timestamp = Time.now
    user.save
  end

end