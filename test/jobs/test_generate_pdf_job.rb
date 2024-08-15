# frozen_string_literal: true

class TestGeneratePdfJob
  include Chromium::Pdf

  def perform(filename, url)
    generate_pdf!(filename, url)
  end
end
