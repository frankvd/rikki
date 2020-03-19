require "./spec_helper"

describe "Rikki::RouteGroup" do
  it "can register a GET route" do
    group = Rikki::RouteGroup.new
    route = group.get "/abcd" do |context, params|
    end

    route.should be_a(Rikki::Route)
    route.method.should eq("GET")
    route.path.should eq("/abcd")
    group.routes.should eq([route])
  end

  it "can register a POST route" do
    group = Rikki::RouteGroup.new
    route = group.post "/abcd" do |context, params|
    end

    route.should be_a(Rikki::Route)
    route.method.should eq("POST")
    route.path.should eq("/abcd")
    group.routes.should eq([route])
  end

  it "can register a PUT route" do
    group = Rikki::RouteGroup.new
    route = group.put "/abcd" do |context, params|
    end

    route.should be_a(Rikki::Route)
    route.method.should eq("PUT")
    route.path.should eq("/abcd")
    group.routes.should eq([route])
  end

  it "can register a PATCH route" do
    group = Rikki::RouteGroup.new
    route = group.patch "/abcd" do |context, params|
    end

    route.should be_a(Rikki::Route)
    route.method.should eq("PATCH")
    route.path.should eq("/abcd")
    group.routes.should eq([route])
  end

  it "can register a DELETE route" do
    group = Rikki::RouteGroup.new
    route = group.delete "/abcd" do |context, params|
    end

    route.should be_a(Rikki::Route)
    route.method.should eq("DELETE")
    route.path.should eq("/abcd")
    group.routes.should eq([route])
  end

  it "can register a OPTIONS route" do
    group = Rikki::RouteGroup.new
    route = group.options "/abcd" do |context, params|
    end

    route.should be_a(Rikki::Route)
    route.method.should eq("OPTIONS")
    route.path.should eq("/abcd")
    group.routes.should eq([route])
  end

  it "can register a route with any method" do
    group = Rikki::RouteGroup.new
    route = group.register "CUSTOM", "/abcd" do |context, params|
    end

    route.should be_a(Rikki::Route)
    route.method.should eq("CUSTOM")
    route.path.should eq("/abcd")
    group.routes.should eq([route])
  end
end
