class Rikki::RouteGroup
  property :routes

  def initialize
    @routes = [] of Route
  end

  def get(path, &handler : (HTTP::Server::Context, Hash(String, String) ->))
    register "GET", path, &handler
  end

  def post(path, &handler : (HTTP::Server::Context, Hash(String, String) ->))
    register "POST", path, &handler
  end

  def put(path, &handler : (HTTP::Server::Context, Hash(String, String) ->))
    register "PUT", path, &handler
  end

  def patch(path, &handler : (HTTP::Server::Context, Hash(String, String) ->))
    register "PATCH", path, &handler
  end

  def delete(path, &handler : (HTTP::Server::Context, Hash(String, String) ->))
    register "DELETE", path, &handler
  end

  def options(path, &handler : (HTTP::Server::Context, Hash(String, String) ->))
    register "OPTIONS", path, &handler
  end

  def register(method, path, &handler : (HTTP::Server::Context, Hash(String, String) ->))
    route = Route.new method, path, handler
    @routes << route
    route
  end
end
