class HardWorker
  include Sidekiq::Worker

  def perform(*args)
    User.all&.each do |user|
      user.recommendations&.each do |rec|
        if rec.current_step == rec.technique.steps.count && !rec.finished_at
          user.user_notifications.create(description: "Rate and finish your technique #{rec.technique.title}",
                                         status: true)
        end
      end
    end
  end
end
