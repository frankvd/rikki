require "./spec_helper"

describe "Rikki::RouterHandler" do
  it "dispatches the matched route" do
    router = Rikki::Router.new
    val = ""
    router.get "/:abc" do |context, params|
      val = params["abc"]
    end

    handler = Rikki::RouterHandler.new router
    context = HTTP::Server::Context.new(HTTP::Request.new("GET", "/test"), HTTP::Server::Response.new(IO::Memory.new))
    handler.call context
    val.should eq("test")
  end
end
