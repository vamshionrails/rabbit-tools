require 'test_helper'

include RabbitMQ::Status

class RabbitToolsStatusTest < Test::Unit::TestCase
  should "format bytes properly" do
    assert_equal "2 bytes", Formatter::ByteFormatter.new.format(2)
    assert_equal "500 bytes", Formatter::ByteFormatter.new.format(500)
    assert_equal "1 KiB", Formatter::ByteFormatter.new.format(1024)
    assert_equal "1 MiB", Formatter::ByteFormatter.new.format(1024 ** 2)
  end

  should "not change the format using the base formatter" do
    assert_equal "2", Formatter::BaseFormatter.new.format("2")
    assert_equal "   -   ", Formatter::BaseFormatter.new.format("   -   ")
  end
end
