require "./spec_helper"

def test_handler(context, params)
  params["a"].should(eq("b"))
  context.response.status_code = 420
end

class TestMiddleware
  include HTTP::Handler

  @@called = 0

  def call(context)
    @@called += 1
    call_next(context)
  end

  def self.called
    @@called
  end
end

describe "Rikki::Router::RouteDispatcher" do
  it "dispatches a route without middleware" do
    route = Rikki::Route.new "GET", "/test", ->test_handler(HTTP::Server::Context, Hash(String, String))
    params = {"a" => "b"}
    dispatcher = Rikki::RouteDispatcher.new route, params

    context = HTTP::Server::Context.new(HTTP::Request.new("GET", "/"), HTTP::Server::Response.new(IO::Memory.new))
    dispatcher.dispatch(context)
    context.response.status_code.should eq(420)
  end

  it "dispatches a route with middleware" do
    route = Rikki::Route.new "GET", "/test", ->test_handler(HTTP::Server::Context, Hash(String, String))
    route.middleware = [TestMiddleware.new, TestMiddleware.new]

    params = {"a" => "b"}
    dispatcher = Rikki::RouteDispatcher.new route, params

    context = HTTP::Server::Context.new(HTTP::Request.new("GET", "/"), HTTP::Server::Response.new(IO::Memory.new))
    dispatcher.dispatch(context)
    context.response.status_code.should eq(420)
    TestMiddleware.called.should eq(2)
  end
end
