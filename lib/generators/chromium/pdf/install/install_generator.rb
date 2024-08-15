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
            N.B. app.json changes are only applied to new heroku apps.
            In the case where your app already exists make sure to manually add the buildpack by running the command:
            `heroku buildpacks:add heroku-community/chrome-for-testing`
          SAY
          add_buildpack_to_app_json
        end

        private

        def add_buildpack_to_app_json
          in_root do
            update_json_file('app.json') do |data|
              if data['buildpacks'].none? { |entry| entry['url'] == 'heroku-community/chrome-for-testing' }
                data['buildpacks'] << { 'url' => 'heroku-community/chrome-for-testing' }
              end
            end
          end
        end

        def update_json_file(file_name)
          data = if File.exist?(file_name)
                   ActiveSupport::JSON.decode(File.read(file_name))
                 else
                   {}
                 end
          data['buildpacks'] ||= []

          yield data

          File.write(file_name, pretty_json(data))
        end

        def pretty_json(data)
          require 'json'
          JSON.pretty_generate(data)
        end
      end
    end
  end
end
