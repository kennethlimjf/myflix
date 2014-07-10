module ApplicationHelper
  def star_options
    [["",nil]] + (1..5).each.map { |i| ["#{pluralize(i, "Star")}", i] } 
  end

  def show_follow_button(user)
    return false if user == current_user || current_user.follow_users.include?(user)
    true
  end

  def register_join_path
    return join_path if @token
    return register_path
  end
end
