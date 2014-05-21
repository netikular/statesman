require_relative "callback"
require_relative "exceptions"

module Statesman
  class Guard < Callback
    attr_reader :message

    def initialize(options = { from: nil, to: nil, message: nil, callback: nil })
      @message = options.delete(:message)
      super(options)
    end

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
