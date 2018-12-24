module RequestHelper
  def self.json_headers
    {
      "ACCEPT" => "application/json",
      "CONTENT_TYPE" => "application/json",
    }
  end
end
