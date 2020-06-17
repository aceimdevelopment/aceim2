class MyCanvas
  require 'canvas-api'
  
  def self.connect
    Canvas::API.new(host: ENV['CANVAS_HOST'], token: ENV['CANVAS_TOKEN'])
  end
end
