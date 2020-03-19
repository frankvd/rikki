require "./spec_helper"

nil_handler = ->(context : HTTP::Server::Context, params : Hash(String, String)) {}

describe "Rikki::Route" do
  it "matches simple paths" do
    route = Rikki::Route.new "GET", "/abcd/123", nil_handler

    route.match("GET", "/abcd/123").should be_a(Regex::MatchData)
    route.match("GET", "/123/abcd").should be_nil
  end

  it "matches the request method" do
    route = Rikki::Route.new "GET", "/abcd/123", nil_handler
    route.match("POST", "/abcd/123").should be_nil
    route.match("GET", "/abcd/123").should be_a(Regex::MatchData)
  end

  it "can match any request method" do
    route = Rikki::Route.new "*", "/abcd/123", nil_handler
    route.match("POST", "/abcd/123").should be_a(Regex::MatchData)
    route.match("GET", "/abcd/123").should be_a(Regex::MatchData)
    route.match("DELETE", "/abcd/123").should be_a(Regex::MatchData)
    route.match("CUSTOM", "/abcd/123").should be_a(Regex::MatchData)
  end

  it "can contain placeholders" do
    route = Rikki::Route.new "GET", "/abcd/:var", nil_handler
    route.match("GET", "/abcd/123").as(Regex::MatchData)["var"].should eq("123")
    route.match("GET", "/abcd/abcd").as(Regex::MatchData)["var"].should eq("abcd")
    route.match("GET", "/abc/abcd").should be_nil
  end

  it "matches complex routes" do
    route = Rikki::Route.new "GET", "/:bbb/some-route/:parts/:aaa/:var/more-parts", nil_handler
    data = route.match("GET", "/var1/some-route/a-b-c/123/L_O_L/more-parts").as(Regex::MatchData)
    data["bbb"].should eq("var1")
    data["parts"].should eq("a-b-c")
    data["aaa"].should eq("123")
    data["var"].should eq("L_O_L")
  end
end
