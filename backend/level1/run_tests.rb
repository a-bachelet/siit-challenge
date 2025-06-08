require_relative 'test/test_helper'

Dir[File.join(__dir__, '**', '*_test.rb')].each { |file| require file }