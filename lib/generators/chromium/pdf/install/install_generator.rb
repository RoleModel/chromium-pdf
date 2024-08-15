# frozen_string_literal: true

require 'rails/generators/base'
require 'rails/generators/active_record'

module Chromium
  module Pdf
    module Generators
      class InstallGenerator < ::Rails::Generators::Base
        desc 'Create template files for pdf generation job'
        source_root File.expand_path('templates', __dir__)

        def create_pdf_job_templates
          copy_file 'app/jobs/generate_pdf_job.rb'
          copy_file 'config/initializers/good_job.rb'
        end

        def include_chrome_buildpack_in_app_json
          say(<<~SAY, :yellow)
            N.B. app.json changes are not applied to existing heroku apps.
            In the case where your app already exists make sure to manually add the buildpack by running the command:
            `heroku buildpacks:add heroku-community/chrome-for-testing`
          SAY
          copy_file 'app.json'
        end
      end
    end
  end
end
