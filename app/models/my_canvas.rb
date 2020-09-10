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

    # Validos:

    # new_section = canvas.post("/api/v1/courses/2146272/sections", {'course_section' => {'name' => 'Prueba'}})
    # new_enroll = canvas.post("/api/v1/sections/2486998/enrollments", {'enrollment' => {'user_id' => 24032737, 'type' => 'StudentEnrollment'}})

    # Pruebas:

    # new_user = canvas.post("/api/v1/accounts/self/users", {'account_user' => {'name' => 'Daniel Moros Prueba', 'short_name' => 'Preuba', 'term_of_use' => true, 'skip_registration' => true}, 'account_pseudonym' => {'unique_id' => 'danielousky@gmail.com', 'send_confirmation' => true, 'force_self_registration' => true }})


    # new_user = canvas.post("/api/v1/accounts/self/users", {'account_user' => {'name' => 'Daniel Moros Prueba', 'term_of_use' => true}, 'account_pseudonym' => {'unique_id' => 'danielousky@gmail.com', 'send_confirmation' => true, 'force_self_registration' => true }})

    # new_user = canvas.post("/api/v1/accounts/self/users", {'pseudonym' => {'unique_id' => 'danielousky@gmail.com' }})

    # canvas.post("/api/v1/accounts/24032737/users", "user": {"name": "Daniel Moros Prueba", "short_name": "Daniel Prueba", "sortable_name": "Moros Daniel", "terms_of_use": "true", "skip_registration": "true"}, "pseudonym": {"unique_id": "daniel@mailinator.com", "send_confirmation": "true", "force_self_registration": "true"})


  end

end
