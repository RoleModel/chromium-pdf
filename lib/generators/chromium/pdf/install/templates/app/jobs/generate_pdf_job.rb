# frozen_string_literal: true

class GeneratePdfJob < ApplicationJob
  JobTimeoutError = Class.new(StandardError)
  include GoodJob::ActiveJobExtensions::Concurrency
  include Chromium::Pdf

  queue_as :pdf
  retry_on Errno::ENOENT, wait: :polynomially_longer, attempts: 3
  retry_on JobTimeoutError, wait: :polynomially_longer, attempts: 3

  good_job_control_concurrency_with(
    enqueue_limit: 1,
    perform_limit: 1,
    key: arguments.first.id
  )

  around_perform do |_job, block|
    Timeout.timeout(180.seconds, JobTimeoutError) do
      block.call
    end
  end

  def perform(model)
    # Any pre-generation logic
    return if model.attachment.attached?

    generate_pdf!(model.filename, model.print_url) do |file, filename|
      # What to do with the generated file
      model.attachment.attach(io: File.open(file.path), filename: filename, content_type: 'application/pdf')
      model.save
    end
  end
end
