class FavoritesMapper
  attr_reader :favorites, :current_user

  def initialize(favorites, current_user)
    @favorites = favorites
    @current_user = current_user
  end

  def self.map(favorites, current_user)
    new(favorites, current_user).map
  end

  def map
    {
      "count" => favorites.length,
      "names" => favorite_names(favorites),
      "current_user_favorite" => favorites.find { |fav| fav["user_id"] == current_user.id },
    }
  end

  MAX_PLUS_ONE_NAMES = 6
  def favorite_names(favorites)
    names = favorites.map { |f| f["user"] && f["user"]["name"] }
    result = names.take(MAX_PLUS_ONE_NAMES).join(', ')
    if names.length <= MAX_PLUS_ONE_NAMES
      result
    else
      "#{result} and #{names.length - MAX_PLUS_ONE_NAMES} more people"
    end
  end
end
