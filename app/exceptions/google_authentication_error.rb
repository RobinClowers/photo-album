class GoogleAuthenticationError < StandardError
  attr_reader :response

  def initialize(message, response = nil)
    @message = message
    @response = response
  end

  def to_s
    if @response
      "#{@message}: #{@response.body}"
    else
      @message
    end
  end
end
