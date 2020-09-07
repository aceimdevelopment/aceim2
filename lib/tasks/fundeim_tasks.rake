desc "Preinscritos 2020C"
task send_email_pre_2020C: :environment do
  p 'iniciando...'

  pe = Period.where(name: '2020-C').first
  AcademicRecord.preinscrito.from_period(pe.id).uniq.each do |ar|

    if UserMailer.preenrollment_2020c(ar.user).deliver
      p '  ENVIADO  '.center(200, "#") 
    else
      p '  NO ENVIADO  '.center(200, "*") 
    end

  end
end

desc "Actualizar valores de las calificaciones"
task update_value_qualifications: :environment do
  p 'Iniciando...'
  PartialQualification.joins(academic_record: {section: {course_period: :period}}).where("periods.name = '2020-B' and value = 0").update_all(value: nil)
  AcademicRecord.where(final_qualification: 0).update_all(final_qualification: -2, qualification_status_id: 'SC')

end

desc "Envío correos asignados 2020-B"
task send_email_asignados2020b: :environment do
  p 'iniciando...'

  AcademicRecord.asignado.from_period(25).map{|a| a.user}.uniq.each do |u|
    if UserMailer.asigneds_2020b(u).deliver
      p '  ENVIADO  '.center(200, "#") 
    else
      p '  NO ENVIADO  '.center(200, "*") 
    end
  end
  # UserMailer.asigneds_2020b(User.find 1).deliver
  p '  FIN  '.center(200, "*") if UserMailer.asigneds_2020b(User.find 1).deliver
  p '  FIN2  '.center(200, "*") if UserMailer.asigneds_2020b(User.find 2).deliver
  
end

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