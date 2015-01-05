class AdminConstraint
  def matches?(request)
    CurrentUser.get(request).admin?
  end
end
