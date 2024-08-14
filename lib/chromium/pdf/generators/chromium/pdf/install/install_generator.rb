# frozen_string_literal: true

require 'rails/generators/base'
require 'rails/generators/active_record'

module Chromium
  module Pdf
    module Generators
      class InstallGenerator < Rails::Generators::Base
        def create_assets_rake_tasks
          create_file 'lib/tasks/assets.rake', <<~RAKE
            # frozen_string_literal: true

            namespace :assets do
              task cleanup: :environment do
                puts 'Removing node_modules...'
                FileUtils.rm_rf(Rails.root.join('node_modules'))
              end
            end

            Rake::Task['assets:precompile'].enhance { Rake::Task['assets:cleanup'].invoke }
          RAKE
        end
      end
    end
  end
end
