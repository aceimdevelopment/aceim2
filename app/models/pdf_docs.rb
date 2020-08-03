class PdfDocs
  include ActionView::Helpers::NumberHelper
  include Prawn::View

  def self.bill_payment payment_detail
    pdf = Prawn::Document.new(top_margin: 50)

    pdf.image "app/assets/images/logo_ucv.png", height: 60, valign: :top, at: [10,710]
    pdf.text "<b>FACTURA PROFORMA</b>", align: :right, size: 15,inline_format: true
    pdf.move_down 20
    pdf.text "<b>#{sprintf('%05i', payment_detail.id)}</b>", align: :right, size: 14, inline_format: true
    pdf.move_down 20
    data = [["<b>#{BankAccount.first.holder}<b>", "<b>Fecha: </b> #{payment_detail.created_at.strftime('%d/%m/%Y')}"]]

    data << ["<b>#{GeneralSetup.fundeim_location_value}<b>", "<b>Cliente: </b> #{payment_detail.client_description}"]
    data << ["<b>#{GeneralSetup.fundeim_phone_value}<b>", ]
    data << ["<b>#{GeneralSetup.fundeim_email_value}<b>", ]

    pdf.table data do |t|
      t.width = 540
      t.header = false
      t.cell_style = {inline_format: true, size: 12, padding: 2, padding: 3, border_color: 'FFFFFF'}
      # t.column(2).style(:align => :justify)
      t.column(0).style(align: :left)
      t.column(1).style(align: :right)
      t.row(1).style(size: 10)
      t.row(2).style(size: 10)
      t.row(3).style(size: 10)
      t.column(1).width = 270
      # t.column(1).style(:font_style => :bold)
    end

    pdf.move_down 80

    data = [["<b>Descripción<b>", "<b>Importe </b>"]]

    total_bs = ActionController::Base.helpers.number_to_currency(payment_detail.mount, unit: 'Bs.', separator: ",", delimiter: ".")

    data << [payment_detail.course_description, total_bs]
    data << ['IVA (16%)', '0 Bs.']
    data << ['<b>TOTAL PROFORMA (Bs.S):</b>', "<b>#{total_bs}</b>"]

    pdf.table data do |t|
      t.position = :center
      t.width = 450
      t.header = true
      t.row_colors = ["F8F8FE","F8F8FE"]
      t.cell_style = {inline_format: true, size: 12, padding: 2, padding: 10, border_color: 'FFFFFF', valign: :center}
      # t.column(2).style(:align => :justify)
      t.row(0).style(background_color: "DCDCDC")
      t.column(0).style(align: :left)
      t.column(1).row(0).style(align: :center)
      t.column(1).row(1).style(align: :right)
      t.column(1).width = 150
      t.row(2).style(align: :right)
      t.row(3).style(size: 14, align: :right, border_color: 'FFFFFF', background_color: "FFFFFF")

      # t.column_widths = {0 => 5, 2 => 120}
      # t.column(1).style(:font_style => :bold)
    end


    return pdf

  end

  def self.certificate academic_record
    pdf = Prawn::Document.new(top_margin: 20)
    content_academic pdf, academic_record
    pdf.move_down 10

    # t = pdf.make_table(data, header: false, width: 540, position: :center, cell_style: { inline_format: true, size: 9, align: :center, padding: 1, border_color: 'FFFFFF'})
    
    # pdf.move_down 20

    pdf.bounding_box [pdf.bounds.left, pdf.bounds.bottom + 25], :width  => pdf.bounds.width do
        pdf.font "Helvetica"
        pdf.stroke_horizontal_rule
        pdf.move_down(5)
        pdf.text 'Cuidad Universitaria de Caracas - FUNDEIM - UCV #VenciendoLaSombra', size: 11, align: :center
    end


    return pdf

  end


  def self.constance career
    pdf = Prawn::Document.new(top_margin: 20, left_margin: 60, right_margin: 60, bottom_margin: 10)

    banner_width_logo pdf, nil, 10
    pdf.move_down 20

    pdf.text '<b>CONSTANCIA</b>', size: 16, align: :center, inline_format: true

    pdf.move_down 15

    pdf.text 'Quien suscribe, Prof. Carlos A. Saavedra A., Director de la Escuela de Idiomas Modernos de la Facultad de Humanidades y Educación de la Universidad Central de Venezuela, hace constar por medio de la presente que el ciudadano:', size: 11, align: :justify
    pdf.move_down 15

    pdf.text "<b>#{career.student.constance_name}</b>", size: 13, align: :center, inline_format: true 
    pdf.move_down 15

    pdf.text "Aprobó del curso <b>#{career.language.name}</b> los niveles que se indican a continuación:", size: 11, align: :justify, inline_format: true

    approved_records pdf, career.academic_records.approved
    
    pdf.text "Cada nivel tiene una duración de 54 horas académicas (9 semanas aproximadamente).", size: 11, align: :justify, inline_format: true

    t = Time.new
    pdf.move_down 15

    pdf.text "Esta constancia se expide a solicitud de la parte interesada.  En Caracas, a los #{t.day} días del mes de #{t.month} de #{t.year}.", size: 11, align: :justify, inline_format: true

    pdf.move_down 70

    pdf.text "Prof. Carlos A. Saavedra A." , align: :center, size: 11
    pdf.move_down 30

    pdf.text "<b>IMPORTANTE:</b> PARA VALIDAR LA AUTENTICIDAD DEL PRESENTE DOCUMENTO ESCANEÉ EL SIGUIENTE CÓDIGO QR CON SU SMARTPHONE:" , align: :justify, size: 11, inline_format: true

    require 'rqrcode'

    qrcode = RQRCode::QRCode.new("https://fundeim.com/careers/#{career.id}/constance")

    png = qrcode.as_png(
      bit_depth: 1,
      border_modules: 4,
      color_mode: ChunkyPNG::COLOR_GRAYSCALE,
      color: 'black',
      file: "tmp/barcode.png",
      fill: 'white',
      module_px_size: 6,
      resize_exactly_to: false,
      resize_gte_to: false,
      size: 150
    )

    pdf.image "#{Rails.root.to_s}/tmp/barcode.png", image_width: 50, image_height: 50, position: :center

    # pdf.image png, position: :center



    pdf.bounding_box [pdf.bounds.left, pdf.bounds.bottom + 35], :width  => pdf.bounds.width do
        pdf.font "Helvetica"
        pdf.stroke_horizontal_rule
        pdf.move_down(5)
        pdf.text 'Cuidad Universitaria de Caracas - FUNDEIM - UCV #VenciendoLaSombra', size: 8, align: :center
        pdf.text GeneralSetup.fundeim_location_value, size: 8, align: :center
        pdf.text GeneralSetup.fundeim_phone_value, size: 8, align: :center

    end
    return pdf

  end


  def self.approved_records pdf, academic_records
    pdf.move_down 25
    data = [['Nivel', 'Período', 'Calificación']]
    academic_records.each do |ar|
      data << ["<b>#{ar.level.name}<b>", "<b>#{ar.period.name}</b>", "<b>#{ar.final_qualification}</b>"]
    end

    # pdf.table([[t,v]], width: 560, cell_style: {border_width: 0})

    pdf.table data do |t|
      t.width = 500
      t.position = :center
      t.header = true
      t.cell_style = {inline_format: true, size: 10, padding: 2, padding: 3, border_color: 'FFFFFF', align: :center}

    end
    pdf.move_down 25
  end



  def self.content_academic pdf, academic_record
    student = academic_record.student
    user = student.user
    payment = academic_record.payment_detail
    
    banner_width_logo pdf, "CONSTANCIA DE INSCRIPCIÓN"


    pdf.text "<b>Datos de la Inscripción:</b>", size: 11, inline_format: true, padding: 3

    # pdf.text "El departamento de Control de Estudios de la Facultad de HUMANIDADES Y EDUCACIÓN, por medio de la presente hace constar que #{usuario.la_el} BR. <b>#{estudiante.usuario.apellido_nombre}</b>, titular de la Cédula de Identidad <b>#{estudiante.id}</b> está <b>preinscrit#{usuario.genero}</b> en la Escuela de <b>#{escuela.descripcion.upcase}</b> de la Universidad Central de Venezuela.", size: 10, inline_format: true, align: :justify
    # Opcion 1:
    # pdf.image "app/assets/images/foto-perfil.png", at: [430, 395], height: 100

    pdf.move_down 20

    data = [['<b>Fecha Registro: <b>', academic_record.created_at.strftime('%d/%m/%Y')]]
    data << ['<b>Estudiante: <b>', user.description]
    data << ['<b>Curso: <b>', academic_record.course_period.course.name]
    data << ['<b>Modalidad: <b>', academic_record.course_period.kind.capitalize]
    data << ['<b>Convenio: <b>', academic_record.agreement.name]
    # data << ['<b>Monto: <b>', "#{number_to_currency(payment.mount, unit: 'Bs.', separator: ",", delimiter: ".")}"]
    data << ['<b>Monto: <b>', "#{payment.mount},00 Bs."] if payment
    data << ["<b>#{payment.transaction_type.capitalize}: <b>", payment.transaction_number ] if payment

    # t = pdf.make_table(data, header: true, row_colors: ["F0F0F0", "FFFFFF"], width: 300, position: :center, cell_style: { inline_format: true, size: 9, align: :center, padding: 3, border_color: '818284'}, :column_widths => {0 => 5, 2 => 120})


    # pdf.table([[t,v]], width: 560, cell_style: {border_width: 0})



    pdf.table data do |t|
      t.width = 540
      t.position = :center
      t.header = false
      # t.row_colors = ["F0F0F0", "FFFFFF"]
      # t.column_widths = {1 => 60, 2 => 220, 5 => 30, 7 => 70}
      t.cell_style = {inline_format: true, size: 9, padding: 2, padding: 3, border_color: 'FFFFFF'}
      # t.column(2).style(:align => :justify)
      t.column(0).style(:align => :right)
      # t.column(1).style(:font_style => :bold)
    end

  end

  def self.banner_width_logo pdf, title = nil, size = nil

    size_logo = size ? size*4 : 50 
    size ||= 12
    pdf.image "app/assets/images/banner_logos_dark.png", position: :center, height: size_logo, valign: :top
    pdf.move_down 3
    pdf.text "UNIVERSIDAD CENTRAL DE VENEZUELA", align: :center, size: size 
    pdf.move_down 3
    pdf.text "Escuela de Idiomas Modernos", align: :center, size: size
    pdf.move_down 3
    pdf.text "FUNDEIM", align: :center, size: size

    pdf.move_down 5
    pdf.text title, align: :center, size: size, style: :bold

    pdf.move_down 5

    # return pdf
  end


  def self.signatures (historial_academico,pdf)
    # -- FIRMAS -----
    # pdf.text "\n\n", :font_size => 8
    # tabla = PDF::SimpleTable.new 
    # tabla.font_size = 11
    # tabla.orientation   = :center
    # tabla.position      = :center
    # tabla.show_lines    = :none
    # tabla.show_headings = false 
    # tabla.shade_rows = :none
    # tabla.column_order = ["nombre", "valor"]

    # tabla.columns["nombre"] = PDF::SimpleTable::Column.new("nombre") { |col|
    #   col.width = 250
    #   col.justification = :center
    # }
    # tabla.columns["valor"] = PDF::SimpleTable::Column.new("valor") { |col|
    #   col.width = 250
    #   col.justification = :center
    # }
    # @persona = (historial_academico.tipo_categoria_id == "NI" || historial_academico.tipo_categoria_id == "TE") ? "Representante" : "Estudiante" 
    # datos = []
    # datos << { "nombre" => to_utf16("<b>__________________________</b>"), "valor" => to_utf16("<b>__________________________</b>") }
    # datos << { "nombre" => to_utf16("Firma #{@persona}"), "valor" => to_utf16("Firma Autorizada y Sello") }
    # tabla.data.replace datos  
    # tabla.render_on(pdf)
    
  end

end
