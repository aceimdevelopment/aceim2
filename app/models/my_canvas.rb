class MyCanvas
  require 'canvas-api'
  
  def self.connect
    Canvas::API.new(host: ENV['CANVAS_HOST'], token: ENV['CANVAS_TOKEN'])
  end


  def create_section_on_canvas(section)
  	# course_id = section.url_classroom_canvas
  	course_id ||= section.course_period.id_canvas
  	self.post("/api/v1/courses/#{course_id}/sections", {course_section: section.name_canvas})

  end

end
