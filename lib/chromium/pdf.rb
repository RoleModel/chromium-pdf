# frozen_string_literal: true

require_relative 'railtie' if defined?(Rails::Railtie)
require_relative 'pdf/version'
require 'active_support/concern'
require 'open3'

module Chromium
  module Pdf
    extend ActiveSupport::Concern

    DEFAULT_CHROME_ARGUMENTS = [
      '--headless',
      '--disable-gpu',
      '--no-pdf-header-footer',
      '--run-all-compositor-stages-before-draw',
      '--no-sandbox',
      '--disable-dev-shm-usage',
      '--disable-background-networking',
      '--virtual-time-budget=10000'
    ].freeze

    ##
    # @param unescaped_filename [String] The filename to save the PDF as.
    # @param print_url [String] The URL of the page you want to be processed.
    # @param arguments [Array<String>] An array of arguments to pass to the Chrome binary.
    # @yield [file, filename] Yields the file object and the filename to the block.
    #
    def generate_pdf!(unescaped_filename, print_url, arguments: DEFAULT_CHROME_ARGUMENTS, &block)
      filename = unescaped_filename.gsub('&', 'and')

      Dir.mktmpdir do |path|
        filepath = "#{path}/#{filename}"
        chrome_print!(print_url, filepath, arguments)

        File.open(filepath) do |file|
          block&.call(file, filename)
        end
      end
    end

    protected

    def logger
      @logger ||= defined?(Rails) && Rails.respond_to?(:logger) ? Rails.logger : Logger.new($stdout)
    end

    def chrome_print!(print_url, pdf_path, arguments)
      chrome_path = ENV.fetch('GOOGLE_CHROME_BIN', 'chrome')

      cmd = [chrome_path, *arguments, "--print-to-pdf=#{pdf_path}", print_url]

      Open3.popen2e({ 'LD_PRELOAD' => '' }, *cmd) do |_stdin, stdout_stderr, _wait_thread|
        stdout_stderr.each_line do |line|
          logger.info(line.chomp)
        end
      end
    end
  end
end
