require 'rack'

class Rack::Mockjax
  def initialize(app, options={})
    @app     = app
    @options = options
  end

  def call(env)
    @status, @headers, @body = @app.call(env)
    insert!
    [@status, @headers, @body]
  end

  def insert!
    mocks = ''.tap do |m|
      Mockjax.mocks.each { |mock| m << "$.mockjax(#{mock.to_json});\n" }
    end
    @body = [@body.join.gsub!(/(<\/head>)/, "<script src='#{Mockjax.path_to_js}' type='text/javascript'></script>\n<script>#{mocks}</script>\\1")]
    @headers['Content-Length'] = Rack::Utils.bytesize(@body.join.to_s).to_s
  end
end
