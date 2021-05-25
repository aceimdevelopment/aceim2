class CanvasController < ApplicationController

  before_action :authenticate_user!

  def sync_up_enrrolled
    section_id_canvas = @enrolled.section.id_canvas
    user = @enrolled.student.user

    if ele = @enrolleds.select{|hash| (hash['user']['login_id'] == user.email or hash['user']['login_id'] == user.canvas_email or hash['user']['login_id'] == user.login_id_canvas)}.first
      return (user.update(id_canvas: ele['user_id'], canvas_email: ele['user']['login_id'], login_id_canvas: ele['user']['login_id']) and @enrolled.update(inscription_status: :asignado))
    else
      return false
    end
  end

  def sync_up_section
    unsyncs = []
    if @section.id_canvas.blank?
      sections = MyCanvas.get_sections_of_course(course_id_canvas)
      canvas_sec = sections.select{|sec| (sec['name'].last 2).to_i == @section.number}.first
      @section.id_canvas = canvas_sec['id'] if canvas_sec
      @section.save
    end

    @enrolleds = MyCanvas.get_enrollments_of_section(@section.id_canvas)

    if instructor_canvas = @enrolleds.select{|hash| hash['role'] == "TaEnrollment"}.first
      email_instr = instructor_canvas['user']['login_id']
      instructor = User.where("email = '#{email_instr}' OR login_id_canvas = '#{email_instr}'").first
      @section.instructor_id = instructor.id if instructor
      @section.save
    end
    @section.academic_records.confirmado.each do |enrolled|
      @enrolled = enrolled
      unless sync_up_enrrolled
        @enrolleds = @enrolleds.reject { |e| e.eql? enrolled}
        unsyncs << enrolled 
      end
    end
    return unsyncs.reject { |e| e.to_s.empty? }
  end

  def sync_up_course_period
    total_sync = []
    @course_period.sections.each do |s|
      @section = s
      total_sync << sync_up_section
    end
    total_sync = total_sync.reject { |e| e.to_s.empty? }

    @course_period.update(response_unenrolled_canvas: course_period.canvas_format_response(total_sync, 'unenrolled'))
    return total_sync
  end

  def write_flash

    if @total_unsyncs.count.eql? 0
      flash[:success] = 'Procesos de sincronización completado con éxito.'
    else
      msg = 'Algunos estudiantes no pudieron ser sincronizados: '
      msg += ' (Se muestran los primeros 50)' if @total_unsyncs.count > 50
      msg += @total_unsyncs[0..50].map{|ar| "Sec#: #{ar.section.number_to_string} - CI: #{ar.student.ci}"}.to_sentence

      flash[:warning] = msg.html_safe
    end
  end

  def sync_with_canvas
    begin
      if params[:entity].eql? 'course_period' or params[:entity].eql? 'section'
        if params[:entity].eql? 'course_period'
          @course_period = CoursePeriod.find params[:id]
          @total_unsyncs = sync_up_course_period
        elsif params[:entity].eql? 'section'
          @section = Section.find params[:id]
          @total_unsyncs = sync_up_section
        end
        write_flash
      elsif params[:entity].eql? 'academic_record'
        @enrolled = AcademicRecord.find params[:id]
        section = @enrolled.section
        @enrolleds = MyCanvas.get_enrollments_of_section(section.id_canvas)
        result = sync_up_enrrolled
        if result.eql? true
          flash[:success] = '¡Usuario sincronizado con éxito!'
        else
          flash[:danger] = "No se pudo sincronizar el usuario."
        end
      else
        flash[:danger] = 'Debe indicar una entidad a sincronizar'
      end
    rescue Exception => e
      flash[:danger] = "Error general: #{e}"
    end
    redirect_back fallback_location: '/admin/course_period'
  end

end
