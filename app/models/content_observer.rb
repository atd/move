class ContentObserver < ActiveRecord::Observer
  observe :document, :bookmark, :article, :photo, :audio

  def after_save(content)
    ContentMailer.deliver_notification(content) if content.notification?
  end
end
