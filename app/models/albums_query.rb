class AlbumsQuery
  attr_reader :current_user

  def initialize(current_user)
    @current_user = current_user
  end

  def active
    if current_user.admin?
      Album.all
    else
      Album.active
    end
  end
end
