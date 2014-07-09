module ApplicationHelper
  def star_options
    [["",nil]] + (1..5).each.map { |i| ["#{pluralize(i, "Star")}", i] } 
  end

  def show_follow_button(user)
    return false if user == current_user || current_user.follow_users.include?(user)
    true
  end
end
