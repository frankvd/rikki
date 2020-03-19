require "http/server/handler"

class Rikki::RouterHandler
  include HTTP::Handler

  property :router

  def initialize(@router : Rikki::Router)
  end

  def call(context)
    route, params = router.match(context)
    unless route.nil?
      route_dispatcher = RouteDispatcher.new route, params
      route_dispatcher.dispatch context
    else
      context.response.respond_with_status(:not_found)
    end

    route

    call_next(context) unless @next.nil?
  end
end
