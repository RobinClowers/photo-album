class UsersWhoCommentedOnPhotoQuery
  def self.execute(photo_id)
    new(photo_id).execute
  end

  def initialize(photo_id)
    @photo_id = photo_id
  end

  def execute
    User.where <<-SQL
      users.id in (
        select user_id
        from comments
        where comments.photo_id = #{@photo_id}
      )
    SQL
  end
end
