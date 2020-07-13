desc "Confirmar y enviar correo de confirmación"
task confirm_and_send_mail: :environment do
  puts 'Iniciando...'
  begin
    puts 'Buscando Estudiantes Inscritos no confirmados...'

    records =  AcademicRecord.preinscrito.not_qualifiqued
    puts " TOTAL REGISTROS A PROCESAR: #{records.count} ".center(220, "*")
    records.each do |ar|

      puts " #{ar.name} ".center(220, "=")
      ar.inscription_status = 'confirmado'
      puts "     Confirmado    ".center(220, "-") if ar.save
      if UserMailer.confirmation_enrollment_email(ar.id).deliver
        puts "     Correo Enviado    ".center(220, "-")
      end

    end

  rescue Exception => e
    puts = "Error: #{e.message}"
  end
  puts 'Finalizado...'
end

desc "Actualizar estados de calificaciones del periodo 2020-A"
task update_records_qua_status_2020a: :environment  do
  p 'Iniciando...'

  begin
    aux = 0
    AcademicRecord.joins(section: :course_period).where("course_periods.period_id = 12 and qualification_status_id = 'SC'").each do |ar|
      printf '.'
      aux += 1 if ar.update(qualification_status_id: ar.build_qualification_status_id)
    end
    p "."
    p " Total registros actualizados!#{aux} ".center(200, "=")
  rescue Exception => e
    p "Error #{e.message}"
  end
  
end