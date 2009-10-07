#  Created by Stefan Saasen.
#  Copyright (c) 2008. All rights reserved.
module RabbitMQ
  module Status
  
    class AbstractCommand
      @@binary = "rabbitmqctl" # rabbitmqctl must be on $PATH
      attr_reader :args, :cmd
    
      def initialize(cmd, args = [])
        @cmd, @args = cmd, args
      end
    
      def run_cmd
        `#{@@binary} #{@cmd} #{@args.join(' ')}`
      end
    
      @protected
      def parse(cmd_output)
        lines = cmd_output.split("\n")
        lines[1..lines.length-2].map{|line| line.split("\t")}
      end
      def list
        parse(run_cmd)
      end
    end

    class Queues < AbstractCommand
      def initialize
        super "list_queues", %w(name durable auto_delete messages_ready messages_unacknowledged messages consumers memory transactions node)
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