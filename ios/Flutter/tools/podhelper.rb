# podhelper.rb
require 'json'
require 'fileutils'

def flutter_root
  generated_xcode_build_settings_path = File.expand_path(File.join('..', 'Flutter', 'Generated.xcconfig'), __FILE__)
  unless File.exist?(generated_xcode_build_settings_path)
    raise "#{generated_xcode_build_settings_path} not found. Run 'flutter pub get' in your Flutter app directory."
  end

  File.foreach(generated_xcode_build_settings_path) do |line|
    return $1 if line =~ /FLUTTER_ROOT=(.*)/
  end
  raise "FLUTTER_ROOT not found in #{generated_xcode_build_settings_path}"
end
