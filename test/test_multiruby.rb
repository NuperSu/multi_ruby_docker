# frozen_string_literal: true

require "test_helper"

class TestMultiruby < Minitest::Test
  def test_that_it_has_a_version_number
    puts "Testing version number..."
    refute_nil ::Multiruby::VERSION
  end

  def test_ruby_ver
    expected_version = ENV.fetch("RUBY_VERSION", "3.3.6").strip.split('-').last
    puts "Checking Ruby version is #{expected_version}..."
    puts "Current Ruby: #{RUBY_VERSION}"
    assert_equal expected_version, RUBY_VERSION
  end
end
