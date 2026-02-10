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
      env_seen = nil
      cmd_seen = nil

      Open3.stub(:popen2e, lambda { |env, *cmd|
        env_seen = env
        cmd_seen = cmd
        # Return a mock that yields a StringIO with output
        mock_io = StringIO.new("Chrome output\n")
        mock_status = Struct.new(:success?).new(true)
        mock_wait_thr = Struct.new(:value).new(mock_status)
        yield nil, mock_io, mock_wait_thr
      }) do
        @job.generate_pdf!('file.pdf', 'http://example.com')
      end

      expected_env = { 'LD_PRELOAD' => '' }
      expected_cmd = [
        'chrome',
        '--headless',
        '--disable-gpu',
        '--no-pdf-header-footer',
        '--run-all-compositor-stages-before-draw',
        '--no-sandbox',
        '--disable-dev-shm-usage',
        '--disable-background-networking',
        '--virtual-time-budget=10000',
        '--print-to-pdf=test/tmp/file.pdf',
        'http://example.com'
      ]

      assert_equal expected_env, env_seen
      assert_equal expected_cmd, cmd_seen
    end
  end

  def test_generate_pdf_yields_to_block
    with_tmp_dir do
      Open3.stub(:popen2e, lambda { |_env, *_cmd|
        mock_io = StringIO.new("Chrome output\n")
        mock_status = Struct.new(:success?).new(true)
        mock_wait_thr = Struct.new(:value).new(mock_status)
        yield nil, mock_io, mock_wait_thr
      }) do
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
