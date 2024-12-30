# frozen_string_literal: true

require "test_helper"

class TestMultiruby < Minitest::Test
  def test_that_it_has_a_version_number
    puts "Testing version number..."
    refute_nil ::Multiruby::VERSION
  end

  def test_ruby_ver
    puts "Checking Ruby version..."
    puts "#{RUBY_VERSION}"
    assert_equal "3.4.1", "#{RUBY_VERSION}"
  end
end
