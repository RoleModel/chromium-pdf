class MyRailtie < Rails::Railtie
  generators do
    require 'chromium/pdf/generators/chromium/pdf/install/install_generator'
  end
end
