class GoogleAuthenticationError < StandardError
  attr_reader :response

  def initialize(message, response)
    @message = message
    @response = response
  end

  def to_s
    "#{@message}: #{@response.body}"
  end
end
