class ProcessVariantsJob < ApplicationJob
  queue_as :default

  def perform(picture)
    picture.file.variant(:thumb).process
    picture.file.variant(:large).process
  end

end
