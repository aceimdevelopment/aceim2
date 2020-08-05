class MyCanvas
  require 'canvas-api'
  
  def self.connect
    Canvas::API.new(host: ENV['CANVAS_HOST'], token: ENV['CANVAS_TOKEN'])
  end

  def get_course(course_id_canvas)
    self.get("/api/v1/courses/#{course_id_canvas}")
  end

  def get_sections_of_course(course_id_canvas)
    self.get("/api/v1/courses/#{course_id_canvas}/sections")
  end

  def get_section(section_id_canvas)
    self.get("/api/v1/sections/#{section_id_canvas}")
  end

  def get_enrollments_to_section(section_id_canvas, type)
    self.get("/api/v1/sections/#{section_id_canvas}/enrollments", {per_page: 80, role: type})
  end

  def create_section_on_canvas(section)
  	# course_id = section.url_classroom_canvas
  	course_id ||= section.course_period.id_canvas
  	self.post("/api/v1/courses/#{course_id}/sections", {course_section: section.name_canvas})

  end

end
