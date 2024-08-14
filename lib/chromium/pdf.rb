# frozen_string_literal: true

require_relative 'pdf/version'

module Chromium
  module Pdf
    ##
    # @param unescaped_filename [String] The filename to save the PDF as.
    # @param print_url [String] The URL of the page you want to be processed.
    # @param arguments [Array<String>] An array of arguments to pass to the Chrome binary.
    # @yield [file, filename] Yields the file object and the filename to the block.
    #
    def generate_pdf!(unescaped_filename, print_url, arguments: ['--headless --disable-gpu'])
      chrome_path = ENV.fetch('GOOGLE_CHROME_BIN', nil)
      filename = unescaped_filename.gsub('&', 'and')

      Dir.mktmpdir do |path|
        filepath = "#{path}/#{filename}"

        system("LD_PRELOAD='' #{chrome_path} --print-to-pdf='#{filepath}' #{arguments.join(' ')} #{print_url} 2> /dev/null")

        File.open(filepath) do |file|
          yield file, filename
        end
      end
    end
  end
end
