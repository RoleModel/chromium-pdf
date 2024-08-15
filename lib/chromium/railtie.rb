# frozen_string_literal: true

require 'rails/railtie'

module Chromium
  module Pdf
    class Railtie < ::Rails::Railtie
      generators do
        require 'generators/chromium/pdf/install/install_generator'
      end
    end
  end
end
