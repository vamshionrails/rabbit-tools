#  Created by Stefan Saasen.
#  Copyright (c) 2008. All rights reserved.
require 'popen4'
module RabbitMQ
  module Status
  
    module Formatter
      class BaseFormatter
        def format(str)
          str # as is
        end
      end
      
      # IEC 60027-2 binary prefix (1 KiB = 1024 bytes)
      class ByteFormatter < BaseFormatter
        UNITS = %w{bytes KiB MiB GiB TiB}
        BYTES = 1024
        def format(str)
          e = (Math.log(str.to_i)/Math.log(BYTES)).floor
          s = "%.3f" % (str.to_f / BYTES**e)
          s.sub(/\.?0*$/, " #{UNITS[e]}")
        end
      end
    end
  
    class AbstractCommand      
      @@binary = "rabbitmqctl" # rabbitmqctl must be on $PATH
      attr_reader :args, :cmd
    
      def initialize(cmd, args = [])
        @cmd, @args = cmd, args
        @formatter = Hash.new(Formatter::BaseFormatter.new)
      end
    
      def run_cmd
        output = nil
        status = POpen4::popen4("#{@@binary} #{@cmd} #{@args.join(' ')}") do |stdout, stderr, stdin, pid|
          output = stdout.read.strip
        end
        status ? output : (raise IOError.new("Failed to execute #{@@binary} - Make sure the RABBITMQ_HOME/sbin directory was added to your PATH"))
      end
    
      @protected
      
      def register_formatter(name, formatter)
        @formatter[name.to_s] = formatter
      end
      
      def parse(cmd_output)
        lines = cmd_output.split("\n")
        lines[1..lines.length-2].map do |line|
          output = []
          line.split("\t").each_with_index do |elem, idx|
            output << @formatter[@args[idx].to_s].format(elem)
          end
          output        
        end#.map{|line| line.split("\t")}
      end
      
      def list
        parse(run_cmd)
      end      
    end

    class Queues < AbstractCommand
      def initialize
        super "list_queues", %w(name durable auto_delete messages_ready messages_unacknowledged messages consumers memory transactions node)
        register_formatter "memory", Formatter::ByteFormatter.new 
      end
    end
  
    class Exchanges < AbstractCommand
      def initialize
        super "list_exchanges",  %w(name durable auto_delete type)
      end
    end
  
    class Bindings < AbstractCommand
      def initialize
        super "list_bindings"
      end
    end
  
    class Connections < AbstractCommand
      def initialize
        super "list_connections", %w(node address port peer_address peer_port state channels user vhost timeout frame_max recv_oct recv_cnt send_oct send_cnt send_pend)
      end
    end
  
  end
end