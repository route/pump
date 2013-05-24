require 'puma'
require 'rack'
require 'drb/drb'
require 'rack/handler/puma'

require 'active_support'
ActiveSupport::SafeBuffer

DRb.start_service

# {
#   "rack.version"=>[1, 2],
#   "rack.errors"=>#<IO:<STDERR>>,
#   "rack.multithread"=>true,
#   "rack.multiprocess"=>false,
#   "rack.run_once"=>false,
#   "SCRIPT_NAME"=>"",
#   "CONTENT_TYPE"=>"text/plain",
#   "QUERY_STRING"=>"",
#   "SERVER_PROTOCOL"=>"HTTP/1.1",
#   "SERVER_SOFTWARE"=>"1.6.3",
#   "GATEWAY_INTERFACE"=>"CGI/1.2",
#   "REQUEST_METHOD"=>"GET",
#   "REQUEST_PATH"=>"/",
#   "REQUEST_URI"=>"/",
#   "HTTP_VERSION"=>"HTTP/1.1",
#   "HTTP_HOST"=>"localhost:8080",
#   "HTTP_USER_AGENT"=>"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_3) AppleWebKit/536.28.10 (KHTML, like Gecko) Version/6.0.3 Safari/536.28.10",
#   "HTTP_ACCEPT"=>"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
#   "HTTP_CACHE_CONTROL"=>"max-age=0",
#   "HTTP_ACCEPT_LANGUAGE"=>"en-us",
#   "HTTP_ACCEPT_ENCODING"=>"gzip, deflate",
#   "HTTP_COOKIE"=>"_cybergifts_session=07a7358249f3a7c4c368833929a9ad6e",
#   "HTTP_CONNECTION"=>"keep-alive",
#   "SERVER_NAME"=>"localhost",
#   "SERVER_PORT"=>"8080",
#   "PATH_INFO"=>"/",
#   "REMOTE_ADDR"=>"127.0.0.1",
#   "puma.socket"=>#<TCPSocket:fd 12>,
#   "rack.input"=>#<Puma::NullIO:0x007fa9142f6790>,
#   "rack.url_scheme"=>"http",
#   "rack.after_reply"=>[]
# }
class RackStack
  def call(env)
    if env['HTTP_HOST'] == 'localhost:8080'
      method_name(env)
    else
      [200, {}, ['Hi!']]
    end
  end

  private

  def method_name(env)
    @app ||= DRbObject.new_with_uri('druby://localhost:8787')
    env.delete('rack.input')
    env.delete('rack.errors')
    env.delete('puma.socket')
    res = @app.call(env)
    # res.last.each do |part|
    #   client.write part.bytesize.to_s(16)
    #   raise part.inspect
    # end
    # raise res.inspect
  end
end

Rack::Handler::Puma.run(RackStack.new)
