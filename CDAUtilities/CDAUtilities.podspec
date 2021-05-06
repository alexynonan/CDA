Pod::Spec.new do |s|
  s.name                  = 'CDAUtilities'
  s.version               = '1.0.0'
  s.platform              = :ios
  s.ios.deployment_target = '11.0'

  # Files reference
  s.source_files          = 'CDAUtilities/Classes/*'

  # Dependency
  
  # Podspec description
  s.summary               = 'A short description of CDAUtilities.'
  s.source                = { :git => 'https://github.com/alexynonan/CDA.git', :tag => s.version.to_s }
  s.homepage              = 'https://github.com/alexynonan/CDA'
  s.license               = { :type => 'MIT', :file => 'LICENSE' }
  s.author                = { 'Alexander Ynoñan Huayllapuma' => 'alexanderynonan@gmail.com' }
end