#--
# Copyright (C) 2008 by Stefan Saasen <s@juretta.com>
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#++
require 'optparse'
require 'ostruct'
require 'terminal-table/import'
Dir[File.join(File.dirname(__FILE__), 'rabbit-tools', '**', '*.rb')].sort.each { |lib| require lib }

# ==Usage
#:include:README.md
module RabbitMQ
  
  class CLI # :nodoc:
    VERSION = "0.3.0"
    
    def initialize
      @out = STDOUT
      @formatter = RabbitMQ::Helper::FormatterFactory.new_formatter
      @options = ::OpenStruct.new
      @options.command = :dump_status
    end
    
    def run(args)
      opts = OptionParser.new do |opts|
        opts.banner = "Usage: #$0 [options]"
        opts.on('-a', '--admin', 'Print vhosts, users and permissions') do
          @options.command = :dump_admin
        end
        opts.on_tail('-h', '--help', 'display this help and exit') do
          puts opts
          exit
        end
        opts.on_tail("--version", "Show version") do
          puts "Version: #{VERSION}"
          exit
        end
        opts.on_tail('--vhost VHOST', 'use the given virtual host') do |vhost|
          @options.vhost = vhost
        end
      end
      opts.parse!(args)
      self.send @options.command, @options
    rescue OptionParser::MissingArgument => e
      puts "Error: #{e}"
    end
    
    private
    
    def dump_admin(options)
      [
        RabbitMQ::Status::Users.new(options), 
        RabbitMQ::Status::Vhosts.new(options),
        RabbitMQ::Status::Permissions.new(options)].each do |status|
        print_status status
      end
    end
    
    def dump_status(options)
      [RabbitMQ::Status::Queues.new(options), 
        RabbitMQ::Status::Exchanges.new(options), 
        RabbitMQ::Status::Bindings.new(options), 
        RabbitMQ::Status::Connections.new(options)].each do |status|
        print_status status
      end
    end
    
    
    def print_status(status)
      begin
        rows = status.list
      rescue => e
        $stderr.puts "\n#{@formatter.red(e)}\n\n"
        exit(-1)
      end
      @out.puts @formatter.yellow(status.description)
      if rows && !rows.empty?
        info = table do |t|
          t.headings = status.header
          rows.each do |lines|
            t << lines
          end
        end
        @out.print info
        @out.puts ""
      else
        @out.puts "-"
      end
      @out.flush
      @formatter.reset!
    end
  end
end

if $0 == __FILE__  
  RabbitMQ::CLI.new.run(ARGV)
end

