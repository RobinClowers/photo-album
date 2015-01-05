class CurrentUser
  def self.get(request)
    new(request).get
  end

  def initialize(request)
    @request = request
  end

  def get
    @current_user ||= user_id && User.find_by_id(user_id) || User::NullUser.new
  end

  def user_id
    @request.session[:user_id]
  end
end
