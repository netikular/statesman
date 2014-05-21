require_relative "callback"
require_relative "exceptions"

module Statesman
  class Guard < Callback
    attr_reader :message

    def call(*args)
      unless super(*args)
        if self.message.empty?
          raise GuardFailedError,
            "Guard on transition from: '#{from}' to '#{to}' returned false"
        else
          raise GuardFailedError, self.message
        end
      end
    end
  end
end
