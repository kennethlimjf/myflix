class ReviewDecorator < Draper::Decorator
  delegate_all

  def rating
    object.rating ? "#{object.rating}.0 / 5.0" : "N/A"
  end
end