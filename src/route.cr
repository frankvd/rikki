require "http/server"

class Rikki::Route
  property :method
  property :path
  property :regex
  property :handler
  property :middleware

  def initialize(@method : String, @path : String, @handler : (HTTP::Server::Context, Hash(String, String) ->))
    @middleware = [] of HTTP::Handler

    escaped = Regex.escape path
    captured = escaped.gsub /\\:([^\/]+)/, "(?<\\1>[^\\/]+)"
    @regex = Regex.new("^" + captured + "$")
  end

  def match(method, path)
    return nil if !method_matches method
    @regex.match path
  end

  def method_matches(method)
    wildcard? || @method == method
  end

  def wildcard?
    method == "*"
  end

  def middleware=(middleware)
    @middleware = [] of HTTP::Handler
    middleware.each do |m|
      @middleware << m
    end
  end
end
