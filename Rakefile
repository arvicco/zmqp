require 'pathname'
BASE_PATH = Pathname.new(__FILE__).dirname
LIB_PATH =  BASE_PATH + 'lib'
PKG_PATH =  BASE_PATH + 'pkg'
DOC_PATH =  BASE_PATH + 'rdoc'

$LOAD_PATH.unshift LIB_PATH.to_s

require 'version'
require 'rake'

NAME = 'zmqp'
CLASS_NAME = ZMQP
VERSION = CLASS_NAME::VERSION

# Load rakefile tasks
Dir['tasks/*.rake'].sort.each { |file| load file }

