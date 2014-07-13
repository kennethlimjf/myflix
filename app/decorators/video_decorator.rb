class VideoDecorator < Draper::Decorator
  delegate_all

  def average_rating
    object.average_rating ? "#{object.average_rating}.0 / 5.0" : "N/A"
  end
end