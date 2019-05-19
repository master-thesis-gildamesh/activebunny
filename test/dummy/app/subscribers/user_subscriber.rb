class UserSubscriber < ActiveBunny::Subscriber

  def create(obj)
    puts "Subscriber: #{obj}"
  end

  # def update(obj)
  #   puts "Subscriber: #{obj}"
  # end

end