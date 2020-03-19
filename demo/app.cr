require "http/server"
require "ecr/macros"
require "../src/rikki"

macro render(filename)
    String.build do |str|
        ECR.embed {{filename}}, str
    end
end

router = Rikki::Router.new
router.get "/abc" do |context|
  context.response.content_type = "text/plain"
  context.response.print "abc"
end

router.get "/hoi/:name/:last" do |context, params|
  context.response.content_type = "text/plain"
  context.response.print "hoi " + params["name"] + " " + params["last"]
end

router.configure do
  get "/configure" do |context|
    context.response.content_type = "text/html"
    context.response.print render(__DIR__ + "/index.ecr")
  end
end

router.with [HTTP::LogHandler.new, HTTP::ErrorHandler.new] do
  get "/log" do |context|
    context.response.content_type = "text/plain"
    context.response.print "logged"
  end
end

print router

server = HTTP::Server.new [Rikki::RouterHandler.new(router)]

addr = server.bind_tcp 8080
puts "Listening on http://#{addr}"
server.listen
