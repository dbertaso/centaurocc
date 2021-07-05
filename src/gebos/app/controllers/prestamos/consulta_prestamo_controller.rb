#encoding: utf-8

class Prestamos::ConsultaPrestamoController < FormTabsController

  skip_before_filter :set_charset, :only=>[:list]

  # llamando a la gema rjb necesaria para tener acceso a las clases de java
  require 'rjb'
  # cargando el jar necesaria para crear archivos pdf
  #logger.info "Root #{Rails.root.to_s}"
  #Rjb::load "#{Rails.root}/lib/iText-2.1.7.jar"
  layout 'form_basic'

  def index
    fill
  end

 

  def list

    params['sort'] = "numero desc" unless params['sort']

    condition = " where prestamo.estatus <> 'S'"
    condition2 = ""
    conditions = ""
    unless params[:identificacion].nil? or params[:identificacion] == ""

      if conditions.empty? 
        conditions << " identificacion LIKE \'%#{params[:tipo]+params[:identificacion].strip}%\'"
      else
        conditions << " and identificacion LIKE \'%#{params[:tipo]+params[:identificacion].strip}%\'"
      end
      @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.cedula_rif_contenga')} '#{params[:tipo]+params[:identificacion]}'"
    end
    unless params[:numero].nil? || params[:numero].to_i <= 0

      if conditions.empty?
        conditions << " numero = #{params[:numero].to_s}" 
      else
        conditions << " and numero = #{params[:numero].to_s}"
      end
      @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.numero_tramite')} '#{params[:numero]}'"
    end

    unless params[:moneda_id].nil? 
      unless params[:moneda_id][0].to_s==''      
        moneda = Moneda.find(params[:moneda_id][0].to_s)
        if conditions.empty?    
          conditions << " moneda_id = #{params[:moneda_id][0].to_s} "
        else
          conditions << " and moneda_id = #{params[:moneda_id][0].to_s} "
        end

        @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.moneda_igual')} '#{moneda.nombre}'"
      end
    end

    unless params[:numero_solicitud].nil? || params[:numero_solicitud].to_i <= 0
      #conditions = "#{conditions} AND (numero_helper =  #{@params[:numero].to_i} OR origen_helper = #{@params[:numero].to_i})"
      if conditions.empty?
        conditions << " numero_solicitud = #{params[:numero_solicitud].to_s} OR numero_origen = #{params[:numero_solicitud].to_s}"
      else
        conditions << " and numero_solicitud = #{params[:numero_solicitud].to_s} OR numero_origen = #{params[:numero_solicitud].to_s}"
      end

      @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.numero_tramite')} '#{params[:numero_solicitud]}'"
    end

    unless params[:nombre].nil? or params[:nombre] == ""
      if conditions.empty?
        conditions << " LOWER(nombre_cliente) LIKE \'%#{params[:nombre].strip.downcase}%\'"
      else
        conditions << " and LOWER(nombre_cliente) LIKE \'%#{params[:nombre].strip.downcase}%\'"
      end

      @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.nombre_apellido')} '#{params[:nombre]}'"
    end

    logger.info "Conditions =====> #{conditions}"
    
    @list = ViewConsultaPrestamos.search(conditions, params[:page], params[:sort])
    @total=@list.count

    form_list

  end

  def tasa_historico_list
    _tasa_historico_list
  end

  def _tasa_historico_list
    @prestamo = Prestamo.find(params[:id])
    conditions = ["prestamo_tasa_historico.prestamo_id = ?", @prestamo.id]
    params['sort'] = "fecha DESC" unless params['sort']
    @prestamo_tasa_historico_total = PrestamoTasaHistorico.count(:conditions=>conditions)

    @prestamo_tasa_historico_list = PrestamoTasaHistorico.search(conditions, params[:page], params[:sort])

    logger.info "Tasa Historico ======> #{@prestamo_tasa_historico_list.inspect}"
    unless @prestamo_tasa_historico_list.nil?
      if request.xhr?
        render :update do |page|
          page.replace_html "tasa_historico_list", :partial => "prestamos/consulta_prestamo/tasa_historico/list", :locals => {:prestamo_tasa_historico => @prestamo_tasa_historico_list}
        end
      end
    end
    
  end

  def tasa_historico_list_view
    _tasa_historico_list
  end

  def view
    @prestamo = Prestamo.find(params[:id])
    @cliente = @prestamo.cliente

    @reestructuracion = Reestructuracion.find_by_solicitud_id(@prestamo.solicitud_id)
    @solicitud = Solicitud.find(@prestamo.solicitud_id)
    @gastos = ProgramaTipoGasto.find_by_programa_id_and_tipo_gasto_id(@solicitud.programa_id, 1)
  end

  def imprimir
    # importando las clases de java necesarias para crear un documento pdf
      pdfwriterclass = Rjb::import("com.lowagie.text.pdf.PdfWriter")
      documentclass = Rjb::import("com.lowagie.text.Document")
      bytearrayclass = Rjb::import("java.io.ByteArrayOutputStream")
      paragraph = Rjb::import("com.lowagie.text.Paragraph")
      imagen = Rjb::import("com.lowagie.text.Image")
      headerfooter = Rjb::import("com.lowagie.text.HeaderFooter")
      color = Rjb::import("java.awt.Color")
      pagesize = Rjb::import("com.lowagie.text.PageSize")
      font =  Rjb::import("com.lowagie.text.Font")
      basefont = Rjb::import("com.lowagie.text.pdf.BaseFont")
      rectangle = Rjb::import("com.lowagie.text.Rectangle")
      element = Rjb::import("com.lowagie.text.Element")
      phrase = Rjb::import("com.lowagie.text.Phrase")
      table = Rjb::import("com.lowagie.text.pdf.PdfPTable")
      celda = Rjb::import("com.lowagie.text.pdf.PdfPCell")
    # fin de la importación de clases
    # creando el documento y configurandolo
      byteArrayInstance = bytearrayclass.new()
      document = documentclass.new(pagesize.LETTER, 60, 50, 50, 30)
      #document.setPageSize(pagesize.LETTER)
      bf_helv = basefont.createFont(basefont.HELVETICA, "Cp1252", false)
      pdfwriterclass.getInstance(document,byteArrayInstance)
      #pdfwriterclass.getInstance(document)
    # fin de la configuración del documento
    headers = phrase.new("\n" + "\n" + "#{I18n.t('Sistema.Body.General.gerencia_administracion_cartera')}",font.new(bf_helv,9,font.BOLD))
    #headers.setAlignment(rectangle.ALIGN_RIGHT)
    header = headerfooter.new(headers, false)
    header.setBorder(2)
    header.setAlignment(element.ALIGN_RIGHT)
    document.setHeader(header)
    footer = headerfooter.new(phrase.new("#{I18n.t('Sistema.Body.General.direccion_institucion')}" + "\n",font.new(bf_helv,9,font.NORMAL)), false)
    footer.setBorder(rectangle.TOP)
    footer.setAlignment(element.ALIGN_CENTER)
    document.setFooter(footer)
    document.open()
    jpeg = imagen.getInstance("app/assets/images/logo_fondas_2.png");
    jpeg.scalePercent(70)
    jpeg.setAbsolutePosition(document.left(), document.top() - 30)
    document.add(jpeg)
    prestamo = Prestamo.find(params[:id])
    t1 = paragraph.new("\n" + "#{I18n.t('Sistema.Body.General.ciudad_institucion')}, #{format_fecha(Time.now)}" + "\n" + "\n",font.new(bf_helv, 12, font.NORMAL))
    t1.setAlignment(element.ALIGN_RIGHT)
    document.add(t1)

    if prestamo.solicitud.cliente.class.to_s == 'ClientePersona'
      t1 = paragraph.new("\n" + "#{I18n.t('Sistema.Body.General.senor')}:" + "\n",font.new(bf_helv, 12, font.NORMAL))
      document.add(t1)
      nombre = prestamo.solicitud.cliente.persona.primer_nombre + ' ' + prestamo.solicitud.cliente.persona.primer_apellido
      nombre = nombre.upcase
      nombre = nombre.gsub('á', 'Á')
      nombre = nombre.gsub('é', 'É')
      nombre = nombre.gsub('í', 'Í')
      nombre = nombre.gsub('ó', 'Ó')
      nombre = nombre.gsub('ú', 'Ú')
      identidad = prestamo.solicitud.cliente.persona.cedula
      t1 = paragraph.new("#{nombre}" + "\n",font.new(bf_helv, 12, font.BOLD))
      texto = "#{I18n.t('Sistema.Body.Controladores.ConsultaPrestamo.Finiquito.prestamo_otorgado_a')}: #{nombre} #{I18n.t('Sistema.Body.Controladores.ConsultaPrestamo.Finiquito.titular_cedula')}: #{identidad}"
    else
      t1 = paragraph.new("#{I18n.t('Sistema.Body.General.senores')}:" + "\n",font.new(bf_helv, 12, font.NORMAL))
      document.add(t1)
      nombre = prestamo.solicitud.cliente.empresa.nombre
      nombre = nombre.upcase
      nombre = nombre.gsub('á', 'Á')
      nombre = nombre.gsub('é', 'É')
      nombre = nombre.gsub('í', 'Í')
      nombre = nombre.gsub('ó', 'Ó')
      nombre = nombre.gsub('ú', 'Ú')
      identidad = prestamo.solicitud.cliente.empresa.rif
      t1 = paragraph.new("#{nombre}" + "\n",font.new(bf_helv, 12, font.BOLD))
      texto = "#{I18n.t('Sistema.Body.Controladores.ConsultaPrestamo.Finiquito.prestamo_otorgado_sociedad')}: #{nombre} #{I18n.t('Sistema.Body.Controladores.ConsultaPrestamo.Finiquito.registro_fiscal')} #{identidad}"
    end
    document.add(t1)
    t1 = paragraph.new("#{I18n.t('Sistema.Body.General.presente')}.-" + "\n" + "\n",font.new(bf_helv, 12, font.NORMAL))
    document.add(t1)
    t1 = paragraph.new("#{I18n.t('Sistema.Body.Controladores.ConsultaPrestamo.Finiquito.texto_finiquito_parte_1')} #{texto}, " +
        "#{I18n.t('Sistema.Body.Controladores.ConsultaPrestamo.Finiquito.texto_finiquito_parte_2')}: #{ViewAperturaComite.monto_escrito(prestamo.capital_pagado,true)} (#{prestamo.capital_pagado_fm}) " +
        "#{I18n.t('Sistema.Body.Controladores.ConsultaPrestamo.Finiquito.texto_finiquito_parte_3')} #{ViewAperturaComite.monto_escrito((prestamo.intereses_pagados + prestamo.mora_pagada), true)} " +
        "(#{prestamo.interes_mora_pagado_fm}) #{I18n.t('Sistema.Body.Controladores.ConsultaPrestamo.Finiquito.texto_finiquito_parte_4')} " +
        "#{I18n.t('Sistema.Body.Controladores.ConsultaPrestamo.Finiquito.texto_finiquito_parte_5')}",font.new(bf_helv, 12, font.NORMAL))
    t1.setAlignment(element.ALIGN_JUSTIFIED)
    document.add(t1)
    t1 = paragraph.new("\n" + "\n",font.new(bf_helv, 12, font.NORMAL))
    document.add(t1)
    t1 = paragraph.new("#{I18n.t('Sistema.Body.Controladores.ConsultaPrestamo.Finiquito.certificacion_parte_interesada')} #{ViewAperturaComite.fecha_escrita(Time.now)}." + "\n",font.new(bf_helv, 12, font.NORMAL))
    document.add(t1)
    t1 = paragraph.new("\n" + "\n" + "#{I18n.t('Sistema.Body.General.atentamente')},",font.new(bf_helv, 12, font.NORMAL))
    t1.setAlignment(element.ALIGN_CENTER)
    document.add(t1)
    firma_autorizada = FirmaAutorizada.detalle_firma("FIRMA11")
    unless firma_autorizada.nil?
      firma_nombre = firma_autorizada.nombre.upcase
      firma_nombre = firma_nombre.gsub('á', 'Á')
      firma_nombre = firma_nombre.gsub('é', 'É')
      firma_nombre = firma_nombre.gsub('í', 'Í')
      firma_nombre = firma_nombre.gsub('ó', 'Ó')
      firma_nombre = firma_nombre.gsub('ú', 'Ú')
      #firma_descripcion = firma_autorizada.descripcion
      firma_descripcion = ""
    else
      firma_nombre = ""
      firma_descripcion = ""
    end
    t1 = paragraph.new("\n" + "\n" + "#{firma_nombre}",font.new(bf_helv, 12, font.BOLD))
    t1.setAlignment(element.ALIGN_CENTER)
    document.add(t1)
    t1 = paragraph.new("#{firma_descripcion}",font.new(bf_helv, 12, font.NORMAL))
    t1.setAlignment(element.ALIGN_CENTER)
    document.add(t1)


    headers = phrase.new("\n" + "\n" + "#{I18n.t('Sistema.Body.General.gerencia_financiamiento')} ",font.new(bf_helv,9,font.BOLD))
    header = headerfooter.new(headers, false)
    header.setBorder(2)
    header.setAlignment(element.ALIGN_RIGHT)
    document.setHeader(header)
    footer = headerfooter.new(phrase.new("",font.new(bf_helv,9,font.NORMAL)), false)
    footer.setBorder(rectangle.TOP)
    footer.setAlignment(element.ALIGN_CENTER)
    document.setFooter(footer)
    document.newPage()
    document.add(jpeg)

    t1 = paragraph.new("\n" + "#{I18n.t('Sistema.Body.General.memorando')}",font.new(bf_helv, 12, font.BOLD))
    t1.setAlignment(element.ALIGN_CENTER)
    document.add(t1)
    t1 = paragraph.new("#{I18n.t('Sistema.Body.General.siglas_gcia_financiamiento')}/#{format_fecha(Time.now)}",font.new(bf_helv, 12, font.NORMAL))
    t1.setAlignment(element.ALIGN_CENTER)
    document.add(t1)

    datatable = table.new(2)
    datatable.setWidths([20,80])
    datatable.setWidthPercentage(100)
    datatable.setHorizontalAlignment(element.ALIGN_CENTER)
    datatable.getDefaultCell().setBorderWidth(0)
    datatable.getDefaultCell().setHorizontalAlignment(element.ALIGN_JUSTIFIED)
    t1 = paragraph.new("\n",font.new(bf_helv, 12, font.BOLD))
    document.add(t1)
    firma_autorizada = FirmaAutorizada.detalle_firma("FIRMA12")
    t1 = paragraph.new("#{I18n.t('Sistema.Body.Vistas.General.para').upcase}:",font.new(bf_helv, 12, font.BOLD))
    datatable.addCell(t1)
    #t1 = paragraph.new(firma_autorizada.nombre + "\n" + firma_autorizada.descripcion + "\n" + "\n",font.new(bf_helv, 12, font.NORMAL))
    t1 = paragraph.new(firma_autorizada.nombre + "\n" + "\n",font.new(bf_helv, 12, font.NORMAL))
    datatable.addCell(t1)
    t1 = paragraph.new("#{I18n.t('Sistema.Body.Vistas.General.de').upcase}:",font.new(bf_helv, 12, font.BOLD))
    datatable.addCell(t1)
    firma_autorizada = FirmaAutorizada.detalle_firma("FIRMA02")
    #t1 = paragraph.new(firma_autorizada.nombre + "\n" + firma_autorizada.descripcion + "\n" + "\n",font.new(bf_helv, 12, font.NORMAL))
    t1 = paragraph.new(firma_autorizada.nombre + "\n" + "\n",font.new(bf_helv, 12, font.NORMAL))
    datatable.addCell(t1)
    t1 = paragraph.new("#{I18n.t('Sistema.Body.General.asunto').upcase}:",font.new(bf_helv, 12, font.BOLD))
    datatable.addCell(t1)
    t1 = paragraph.new("#{I18n.t('Sistema.Body.Controladores.ConsultaPrestamo.Finiquito.certificacion_parte_interesada')} - #{nombre}" + "\n" + "\n",font.new(bf_helv, 12, font.NORMAL))
    datatable.addCell(t1)
    t1 = paragraph.new("#{I18n.t('Sistema.Body.Vistas.Form.fecha').upcase}:",font.new(bf_helv, 12, font.BOLD))
    datatable.addCell(t1)
    t1 = paragraph.new(format_fecha(Time.now),font.new(bf_helv, 12, font.NORMAL))
    datatable.addCell(t1)
    document.add(datatable)
    t1 = paragraph.new("\n",font.new(bf_helv, 12, font.NORMAL))
    document.add(t1)
    datatable = table.new(1)
    datatable.setWidths([100])
    datatable.setWidthPercentage(100)
    datatable.setHorizontalAlignment(element.ALIGN_CENTER)
    datatable.getDefaultCell().setBorderWidth(0)
    datatable.getDefaultCell().setHorizontalAlignment(element.ALIGN_JUSTIFIED)
    cel = celda.new(paragraph.new(" ",font.new(bf_helv, 12, font.NORMAL)))
    cel.setBackgroundColor(color.decode("#d5d3d3"))
    cel.setBorderWidth(0)
    cel.setHorizontalAlignment(element.ALIGN_CENTER)
    datatable.addCell(cel)
    document.add(datatable)
    t1 = paragraph.new("\n",font.new(bf_helv, 12, font.NORMAL))
    document.add(t1)
    factura = Factura.find(:first, :conditions=>['prestamo_id = ?', prestamo.id], :order=> 'id desc')
    if factura.nil? || factura.fecha_contable.nil?
      fecha = "#{format_fecha(Time.now)} #{I18n.t('Sistema.Body.General.fecha_de_hoy')}"
    else
      fecha = format_fecha(factura.fecha_contable)
    end
    t1 = paragraph.new("#{I18n.t('Sistema.Body.Controladores.ConsultaPrestamo.Finiquito.tengo_honor_de_dirigirme')}: " +
        "#{nombre}, #{I18n.t('Sistema.Body.Controladores.ConsultaPrestamo.Finiquito.titular_registro_fiscal')} #{identidad}, " +
        "#{I18n.t('Sistema.Body.Controladores.ConsultaPrestamo.Finiquito.el_cual_fue_otorgado')}: " +
        "#{ViewAperturaComite.monto_escrito(prestamo.solicitud.monto_solicitado, true)} (" +
        "#{prestamo.solicitud.monto_solicitado_fm}), #{I18n.t('Sistema.Body.Controladores.ConsultaPrestamo.Finiquito.totalmente_cancelado')} #{fecha}." + "\n" + "\n"  +
        "#{I18n.t('Sistema.Body.Controladores.ConsultaPrestamo.Finiquito.en_este_sentido')}." +
        "\n" + "\n" + "#{I18n.t('Sistema.Body.Controladores.ConsultaPrestamo.Finiquito.asi_mismo')} " +
        "\n" + "\n" + "#{I18n.t('Sistema.Body.Controladores.ConsultaPrestamo.Finiquito.sin_otro_particular')},",font.new(bf_helv, 12, font.NORMAL))
    t1.setAlignment(element.ALIGN_JUSTIFIED)
    document.add(t1)
    t1 = paragraph.new("\n" + "#{I18n.t('Sistema.Body.General.atentamente')}," + "\n" + "\n",font.new(bf_helv, 12, font.NORMAL))
    t1.setAlignment(element.ALIGN_CENTER)
    document.add(t1)
    firma_autorizada = FirmaAutorizada.detalle_firma("FIRMA02")
    unless firma_autorizada.nil?
      firma_nombre = firma_autorizada.nombre.upcase
      firma_nombre = firma_nombre.gsub('á', 'Á')
      firma_nombre = firma_nombre.gsub('é', 'É')
      firma_nombre = firma_nombre.gsub('í', 'Í')
      firma_nombre = firma_nombre.gsub('ó', 'Ó')
      firma_nombre = firma_nombre.gsub('ú', 'Ú')
      #firma_descripcion = firma_autorizada.descripcion
      firma_descripcion = ""
    else
      firma_nombre = ""
      firma_descripcion = ""
    end

    t1 = paragraph.new("\n" + "\n" + "#{firma_nombre}",font.new(bf_helv, 12, font.BOLD))
    t1.setAlignment(element.ALIGN_CENTER)
    document.add(t1)
    t1 = paragraph.new("#{firma_descripcion}",font.new(bf_helv, 12, font.NORMAL))
    t1.setAlignment(element.ALIGN_CENTER)
    document.add(t1)
    document.close()

    fileinbytes = byteArrayInstance.toByteArray()
    # rendiar el documento
    send_data(fileinbytes, {:filename => "#{I18n.t('Sistema.Body.Controladores.ConsultaPrestamo.Finiquito.nombre_archivo')}_#{prestamo.numero}.pdf", :type => "application/pdf"})
  end

  protected
  def common
    super
    @form_title = I18n.t('Sistema.Body.Controladores.ConsultaPrestamo.FormTitles.form_title')
    @form_title_record = I18n.t('Sistema.Body.Controladores.ConsultaPrestamo.FormTitles.form_title')
    @form_title_records = I18n.t('Sistema.Body.Controladores.ConsultaPrestamo.FormTitles.form_title')
    @form_entity = 'prestamo'
    @form_identity_field = 'numero'
    @width_layout = '1200'
  end

  private

  def fill

    logger.debug "Entry in fill"
    @programa_list = Programa.find(:all,:conditions=>"activo=true",:order=>'nombre')
    sentencia="SELECT mon.id AS id, mon.abreviatura,mon.nombre,        
        CASE
            WHEN mon.id = par.moneda_id THEN 
            '1'::text
            ELSE '0'::text
        END AS no_va
   FROM moneda mon,parametro_general par 
   where mon.activo=true order by no_va desc, nombre;"
   logger.info "Paso por consulta de moneda"
    @moneda_list=Moneda.find_by_sql(sentencia)

  logger.info "Moneda_List ========> #{@moneda_list.inspect}"
    #@tipo_cartera = TipoCartera.all(:order=>'nombre')
  end
end

