module ValidateURL
  BLACKLISTED_HOSTS = Set.new(%w(
    localhost 127.0.0.1
  )).freeze

  def self.valid?(url)
    uri = URI.parse(url || '')
    return false if BLACKLISTED_HOSTS.include?(uri.host)
    return true if uri.absolute?
    false
  end
end
