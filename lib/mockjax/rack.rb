require 'rack'

class Rack::Mockjax
  def initialize(app, options={})
    @app     = app
    @options = options
  end

  def call(env)
    @status, @headers, @response = @app.call(env)
    insert!
    [@status, @headers, @response]
  end

  def insert!
    mocks = ''.tap do |m|
      Mockjax.mocks.each { |mock| m << "$.mockjax(#{mock.to_json});\n" }
    end
    if @response.is_a? ActionDispatch::Response
      @response.body = @response.body.gsub!(/(<\/head>)/, "<script src='#{Mockjax.path_to_js}' type='text/javascript'></script>\n<script>#{mocks}</script>\\1")
    end
  end
end
