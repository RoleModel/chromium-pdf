# frozen_string_literal: true

require 'test_helper'

class Chromium::TestPdf < Minitest::Test
  TMP_PATH = 'test/tmp'

  def setup
    @job = Class.new do
      include Chromium::Pdf
    end.new
  end

  def test_job_includes_pdf_concern
    assert_respond_to @job, :generate_pdf!
  end

  def test_generate_pdf_calls_executes_correct_chrome_command # rubocop:disable Metrics/MethodLength
    with_tmp_dir do
      args_seen = nil
      Kernel.stub(:system, lambda { |*args|
        args_seen = args
        true
      }) do
        @job.generate_pdf!('file.pdf', 'http://example.com')
      end

      expected_args = [
        { 'LD_PRELOAD' => '' },
        'chrome',
        '--headless',
        '--disable-gpu',
        '--no-pdf-header-footer',
        '--run-all-compositor-stages-before-draw',
        '--no-sandbox',
        '--disable-dev-shm-usage',
        '--disable-background-networking',
        '--print-to-pdf=test/tmp/file.pdf',
        'http://example.com',
        exception: true
      ]

      assert_equal expected_args, args_seen
    end
  end

  def test_generate_pdf_yields_to_block
    with_tmp_dir do
      Kernel.stub :system, :ran do
        @job.generate_pdf!('file.pdf', 'url') do |file, filename|
          assert_equal "hello world\n", file.read
          assert_equal 'file.pdf', filename
        end
      end
    end
  end

  def with_tmp_dir(&with_block)
    Dir.stub(:mktmpdir, ->(*_args, &block) { block.call(TMP_PATH) }, &with_block)
  end
end
