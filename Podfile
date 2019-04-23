platform :ios, '11.0'

# ignore all warnings from all pods
inhibit_all_warnings!

def pods
  pod 'SnapKit', '~> 4.0.0'
end

def testing_pods
  pod 'Quick', '1.3.1'
  pod 'Nimble', '8.0.1'
end

target 'Aspetica' do
  pods
end

target 'AspeticaTests' do
  inherit! :search_paths
  pods
  testing_pods
end

target 'AspeticaUITests' do
  inherit! :search_paths
  pods
  testing_pods
end
