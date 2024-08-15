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
      end
    end
  end
end
