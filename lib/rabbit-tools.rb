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
require 'terminal-table/import'
Dir[File.join(File.dirname(__FILE__), 'rabbit-tools', '**', '*.rb')].sort.each { |lib| require lib }

# ==Usage
#:include:README.md
module RabbitMQ
  
  class CLI # :nodoc:
    
    def initialize
      @out = STDOUT
      @formatter = RabbitMQ::Helper::FormatterFactory.new_formatter
    end
    
    def run(args)
      
      # TODO 
      #   Extract command line args to specify the rabbitmqctl binary
      
      [RabbitMQ::Status::Queues.new, 
        RabbitMQ::Status::Exchanges.new, 
        RabbitMQ::Status::Bindings.new, 
        RabbitMQ::Status::Connections.new].each do |status|
        
        begin
          rows = status.list
        rescue => e
          $stderr.puts "\n#{@formatter.red(e)}\n\n"
          exit(-1)
        end
        @out.puts @formatter.yellow(status.cmd)
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
end

if $0 == __FILE__  
  RabbitMQ::CLI.new.run(ARGV)
end

