module ValidateURL
  def self.valid?(url)
    return true if URI.parse(url || '').absolute?
    false
  end
end
