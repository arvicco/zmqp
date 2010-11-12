# For more information on bundler, please visit http://gembundler.com

source :gemcutter
gem 'cucumber'

# We need FFI HEAD that solves some threading issues with MRI/1.9.2
gem 'ffi', '>=0.6.3' #, git: 'https://github.com/ffi/ffi.git'
gem 'zmqmachine'

group :cucumber do
  gem 'cucumber'
  gem 'rspec', '~>2.0.0', require: ['rspec/expectations', 'rspec/stubs/cucumber']
  # add more here...
end

group :test do
  gem 'rspec', '~>2.0.0', require: ['rspec', 'rspec/autorun']
#  gem 'amqp-spec', '>=0.1.8', git: 'git://github.com/arvicco/amqp-spec.git', require: 'amqp-spec/rspec'
end

