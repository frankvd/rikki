class Rikki::Router
  property :default_route_group
  property :route_groups

  def initialize
    @default_route_group = RouteGroup.new
    @route_groups = [@default_route_group]
  end

  def match(context)
    method = context.request.method
    path = context.request.path

    route = nil
    match_data = nil
    @route_groups.each do |group|
      if route.nil?
        group.routes.each do |r|
          if match_data = r.match method, path
            route = r
            break
          end
        end
      else
        break
      end
    end
    return nil, Hash(String, String).new if route.nil? || match_data.nil?
    return route, match_data.named_captures.compact
  end

  def with(middleware : Array(HTTP::Handler))
    group = RouteGroup.new
    with group yield
    @route_groups << group

    group.routes.each do |route|
      route.middleware = middleware
    end
  end

  def configure
    with self yield
  end

  def get(path, &handler : (HTTP::Server::Context, Hash(String, String) ->))
    @default_route_group.get(path, &handler)
  end

  def post(path, &handler : (HTTP::Server::Context, Hash(String, String) ->))
    @default_route_group.post(path, &handler)
  end

  def put(path, &handler : (HTTP::Server::Context, Hash(String, String) ->))
    @default_route_group.put(path, &handler)
  end

  def patch(path, &handler : (HTTP::Server::Context, Hash(String, String) ->))
    @default_route_group.patch(path, &handler)
  end

  def delete(path, &handler : (HTTP::Server::Context, Hash(String, String) ->))
    @default_route_group.delete(path, &handler)
  end

  def options(path, &handler : (HTTP::Server::Context, Hash(String, String) ->))
    @default_route_group.options(path, &handler)
  end

  def register(method, path, &handler : (HTTP::Server::Context, Hash(String, String) ->))
    @default_route_group.register(method, path, &handler)
  end

  def to_s(io)
    @route_groups.each do |group|
      group.routes.each do |route|
        io << route.method
        io << "\t"
        io << route.path
        io << "\t"
        io << route.middleware.map { |m| m.class }
        io << "\n"
      end
    end
  end
end
