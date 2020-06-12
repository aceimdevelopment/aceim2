desc "Confirmar y enviar correo de confirmación"
task confirm_and_send_mail: :environment do
  puts 'Iniciando...'
  begin
    puts 'Buscando Estudiantes Inscritos no confirmados...'

    records =  AcademicRecord.preinscrito.not_qualifiqued
    puts " TOTAL REGISTROS A PROCESAR: #{records.count} ".center(220, "*")
    AcademicRecord.preinscrito.not_qualifiqued.each do |ar|

      puts " #{ar.name} ".center(220, "=")
      ar.inscription_status = 'confirmado'
      puts "     Confirmado    ".center(220, "-") if ar.save
      if UserMailer.confirmation_enrollment_email(ar).deliver
        puts "     Correo Enviado    ".center(220, "-")
      end

    end

  rescue Exception => e
    puts = "Error: #{e.message}"
  end
  puts 'Finalizado...'
end