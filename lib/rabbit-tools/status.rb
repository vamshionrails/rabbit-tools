#  Created by Stefan Saasen.
#  Copyright (c) 2008. All rights reserved.
require 'popen4'
module RabbitMQ

  module Status # :nodoc: all
  
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
      attr_reader :cmd
      attr_writer :header
      attr_accessor :description
    
      def initialize(cmd, args = [])
        @cmd, @args, @header = cmd, args, []
        @formatter = Hash.new(Formatter::BaseFormatter.new)
      end
    
      def header
        @header.empty? ? @args : @header
      end
      
      def description
        @description.nil? ? @cmd : @description
      end
    
      @private
      def execute_cmd(cmd, args = [])
        output = nil
        status = POpen4::popen4("#{@@binary} #{cmd} #{args.join(' ')}") do |stdout, stderr, stdin, pid|
          output = stdout.read.strip
        end
        status ? output : (raise IOError.new("Failed to execute #{@@binary} - Make sure the RABBITMQ_HOME/sbin directory was added to your PATH"))
      end
      
      def register_formatter(name, formatter)
        @formatter[name.to_s] = formatter
      end
      
      def parse_cmd(cmd, args = [])
        cmd_output= execute_cmd(cmd, args)
        print "cmd_output: #{cmd_output}" if $DEBUG
        lines = cmd_output.split("\n")
        lines[1..lines.length-2].map do |line|
          output = []
          line.split("\t").each_with_index do |elem, idx|
            output << @formatter[@args[idx].to_s].format(elem)
          end
          output        
        end
      end
      
      def list
        parse_cmd(@cmd, @args)
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
        self.header = ["exchange name", "routing key", "queue name", "binding arguments"]
      end
    end
  
    class Connections < AbstractCommand
      def initialize
        super "list_connections", %w(node address port peer_address peer_port state channels user vhost timeout frame_max recv_oct recv_cnt send_oct send_cnt send_pend)
      end
    end
  
    class Users < AbstractCommand
      def initialize
        super "list_users"
        self.header = ["username"]
      end
    end # Users
  
    class Vhosts < AbstractCommand
      def initialize
        super "list_vhosts"
        self.header = ["vhost"]
      end
    end # Vhosts
  
    class Permissions < AbstractCommand
      def initialize(host = '/')
        super "list_permissions"
        self.header, @host = ["host", "user", "configure permission", "write permission", "read permission"], host
        @hosts = parse_cmd("list_vhosts")
      end
      
      def list
        @hosts.map do |host|
          parse_cmd(@cmd, ["-p #{host}"]).flatten.unshift host
        end
      end
    end # Permissions
  end
end