# frozen_string_literal: true

require 'test_helper'
require 'rails/generators'
require 'lib/generators/chromium/pdf/install/install_generator'

class InstallGeneratorTest < Rails::Generators::TestCase
  tests ::Chromium::Pdf::Generators::InstallGenerator
  destination File.expand_path('../../tmp', __dir__)
  setup do
    prepare_destination
    @app_json_path = "#{destination_root}/app.json"
  end

  test 'pdf job template is created' do
    run_generator
    assert_file 'app/jobs/generate_pdf_job.rb'
  end

  test 'good job initializer is created' do
    run_generator
    assert_file 'config/initializers/good_job.rb'
  end

  test 'app.json is correct' do
    File.write(@app_json_path, ActiveSupport::JSON.encode({}))
    run_generator
    assert_includes(File.read(@app_json_path), 'heroku-community/chrome-for-testing')

    File.write(@app_json_path, ActiveSupport::JSON.encode({ buildpacks: [] }))
    run_generator
    assert_includes(File.read(@app_json_path), 'heroku-community/chrome-for-testing')
  end

  test 'does not duplicate the buildpack in app.json' do
    File.write(@app_json_path,
      ActiveSupport::JSON.encode({ buildpacks: [{ 'url' => 'heroku-community/chrome-for-testing' }] }))

    run_generator
    found = ActiveSupport::JSON.decode(File.read(@app_json_path))['buildpacks'].select do |entry|
      entry['url'] == 'heroku-community/chrome-for-testing'
    end
    assert_equal(1, found.size)
  end
end
