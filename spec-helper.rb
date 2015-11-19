gem 'minitest'
require 'minitest/autorun'
require 'minitest/spec'

$LOAD_PATH.unshift('.', 'lib', 'spec')

class Object
  def _describe( test )
    puts "--- On saute les tests pour \"#{test}\" ---"
  end

  def _it( test )
    puts "--- On saute le test \"#{test}\" ---"
  end
end
