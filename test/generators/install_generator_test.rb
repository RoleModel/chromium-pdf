# frozen_string_literal: true

require 'test_helper'
require 'rails/generators'
require 'lib/generators/chromium/pdf/install/install_generator'

class InstallGeneratorTest < Rails::Generators::TestCase
  tests ::Chromium::Pdf::Generators::InstallGenerator
  destination File.expand_path('../../tmp', __dir__)
  setup :prepare_destination

  test 'pdf job template is created' do
    run_generator
    assert_file 'app/jobs/generate_pdf_job.rb'
  end

  test 'good job initializer is created' do
    run_generator
    assert_file 'config/initializers/good_job.rb'
  end

  test 'app.json is created' do
    run_generator
    assert_file 'app.json'
  end
end
