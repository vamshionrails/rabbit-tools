#  Created by Stefan Saasen.
#  Copyright (c) 2008. All rights reserved.
module RabbitMQ
  
  module Helper # :nodoc: all
    
      class FormatterFactory
        class << self
          def new_formatter
            STDIN.tty? ? ColorFormatter.new : NoopFormatter.new
          end
        end
      end
    
      class NoopFormatter
        def method_missing(sym)
          # noop
        end
      end
    
      class ColorFormatter
        def initialize
          reset!
        end

        def yellow(txt)
          @buffer << "\033[33m#{txt}\033[0m"
          self
        end

        def red(txt)
          @buffer << "\033[1;31m#{txt}\033[0m"
          self
        end

        def blue(txt)
          @buffer << "\033[1;34m#{txt}\033[0m"
          self
        end

        def green(txt)
          @buffer << "\033[1;32m#{txt}\033[0m"
          self
        end

        def clear(txt)
          @buffer << txt
          self
        end

        def reset!
          @buffer = []
        end

        def to_s
          @buffer.join('')
        end
      end
       
  end
end