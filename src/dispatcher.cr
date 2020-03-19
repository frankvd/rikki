class Rikki::RouteDispatcher
  property :route
  property :params

  def initialize(@route : Route, @params : Hash(String, String))
  end

  def dispatch(context)
    if @route.middleware.empty?
      @route.handler.call(context, @params)
    else
      handlers = @route.middleware + [InnerHandler.new(@route, @params)]
      handler = HTTP::Server.build_middleware handlers
      handler.call context
    end
  end

  private class InnerHandler
    include HTTP::Handler

    property :route
    property :params

    def initialize(@route : Route, @params : Hash(String, String))
    end

    def call(context)
      @route.handler.call context, @params
    end
  end
end
