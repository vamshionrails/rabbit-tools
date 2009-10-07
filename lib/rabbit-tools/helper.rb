#  Created by Stefan Saasen.
#  Copyright (c) 2008. All rights reserved.
module RabbitMQ
  module Helper
      class Formatter
        def initialize
          reset!
        end

        def yellow(txt)
          @buffer << "\033[33m#{txt}\033[0m"
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