# frozen_string_literal: true

module Chromium
  module Pdf
    class Railtie < Rails::Railtie
      generators do
        require 'chromium/pdf/generators/chromium/pdf/install/install_generator'
      end
    end
  end
end
