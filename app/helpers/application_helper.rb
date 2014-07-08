module ApplicationHelper
  def star_options
    [["",nil]] + (1..5).each.map { |i| ["#{pluralize(i, "Star")}", i] } 
  end
end
