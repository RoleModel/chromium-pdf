# frozen_string_literal: true

require 'test_helper'
require 'test/jobs/test_generate_pdf_job'

class Chromium::TestPdf < Minitest::Test
  def test_job_includes_pdf_concern
    assert_respond_to TestGeneratePdfJob.new, :generate_pdf!
  end

  def test_generate_pdf_calls_chrome_print
    job = TestGeneratePdfJob.new
    job.stub :chrome_print, :ran do
      assert_equal :ran, job.generate_pdf!('filename', 'url')
    end
  end

  def test_chrome_print_calls_file_open
    job = TestGeneratePdfJob.new
    File.stub :open, :ran do
      result = job.send(:chrome_print, 'chrome', 'url', 'name', 'path', ['argument']) do |_file, filename|
        assert_equal 'name', filename
      end
      assert_equal :ran, result
    end
  end
end
