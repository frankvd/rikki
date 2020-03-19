require "./spec_helper"

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

describe "Rikki::Router" do
  it "registers a route" do
    router = Rikki::Router.new
    route = router.get "/" do |context, params|
    end

    route.should be_a(Rikki::Route)
    router.default_route_group.routes.should eq([route])
  end

  it "registers routes with middleware" do
    router = Rikki::Router.new
    route = nil
    middleware = TestMiddleware.new
    router.with [middleware] do
      route = get "/" do |context, params|
      end
    end

    router.route_groups.size.should eq(2)
    router.route_groups.last.routes.first.should be_a(Rikki::Route)
    router.route_groups.last.routes.first.should eq(route)
    router.route_groups.last.routes.first.middleware.should eq([middleware])
  end

  it "matches a route to a context" do
    router = Rikki::Router.new
    expected = nil
    router.configure do
      get "/" do |context, params|
      end

      expected = get "/abcd" do |context, params|
      end

      get "/abc" do |context, params|
      end
    end

    context = HTTP::Server::Context.new(HTTP::Request.new("GET", "/abcd"), HTTP::Server::Response.new(IO::Memory.new))
    route, match_data = router.match(context)
    route.should be_a(Rikki::Route)
    route.should be(expected)
  end
end
