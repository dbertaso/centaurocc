# encoding: utf-8

class Solicitudes::SolicitudConsultoriaJuridicaHistoricoController < FormClassicController
  
  skip_before_filter :set_charset, :only=>[:sector_change, :sector_form_change, :sub_sector_change, :sub_sector_form_change, :rubro_change, :rubro_form_change, :sub_rubro_change, :sub_rubro_form_change, :generar, :acta_entrega, :generar_NA]
  
  def index
    sub_sector_fill(0)
    rubro_fill(0)
    sub_rubro_fill(0)
    actividad_fill(0)
    @sector = Sector.find(:all, :order => 'nombre')
    @moneda_list = Moneda.find(:all, :conditions=> "activo = true", :order => "nombre")
  end

  def sector_change
    sub_sector_fill(params[:sector_id])
    render :update do |page|
      page.replace_html 'sub-sector-select', :partial => 'sub_sector_select'
      page.replace_html 'rubro-select', :partial => 'rubro_select'
      page.replace_html 'sub-rubro-select', :partial => 'sub_rubro_select'
      page.replace_html 'actividad-select', :partial => 'actividad_select'
      page.show 'sub-sector-select'
      page.show 'rubro-select'
      page.show 'sub-rubro-select'
      page.show 'actividad-select'
    end
  end

  def sector_form_change
    sub_sector_fill(params[:sector_id])
    render :update do |page|
      page.replace_html 'sub-sector-select', :partial => 'sub_sector_form_select'
      page.replace_html 'rubro-select', :partial => 'rubro_form_select'
      page.replace_html 'sub-rubro-select', :partial => 'sub_rubro_form_select'
      page.replace_html 'actividad-select', :partial => 'actividad_form_select'
      page.show 'sub-sector-select'
      page.show 'rubro-select'
      page.show 'sub-rubro-select'
      page.show 'actividad-select'
    end
  end

  def sub_sector_change
    rubro_fill(params[:sub_sector_id])
    render :update do |page|
      page.replace_html 'rubro-select', :partial => 'rubro_select'
      page.replace_html 'sub-rubro-select', :partial => 'sub_rubro_select'
      page.replace_html 'actividad-select', :partial => 'actividad_select'
      page.show 'rubro-select'
      page.show 'sub-rubro-select'
      page.show 'actividad-select'
    end
  end

  def sub_sector_form_change
    rubro_fill(params[:sub_sector_id])
    render :update do |page|
      page.replace_html 'rubro-select', :partial => 'rubro_form_select'
      page.replace_html 'sub-rubro-select', :partial => 'sub_rubro_form_select'
      page.replace_html 'actividad-select', :partial => 'actividad_form_select'
      page.show 'rubro-select'
      page.show 'sub-rubro-select'
      page.show 'actividad-select'
    end
  end

  def rubro_change
    sub_rubro_fill(params[:rubro_id])
    render :update do |page|
      page.replace_html 'sub-rubro-select', :partial => 'sub_rubro_select'
      page.replace_html 'actividad-select', :partial => 'actividad_select'
      page.show 'sub-rubro-select'
      page.show 'actividad-select'
    end
  end

  def rubro_form_change
    sub_rubro_fill(params[:rubro_id])
    render :update do |page|
      page.replace_html 'sub-rubro-select', :partial => 'sub_rubro_form_select'
      page.replace_html 'actividad-select', :partial => 'actividad_form_select'
      page.show 'sub-rubro-select'
      page.show 'actividad-select'
    end
  end

  def sub_rubro_change
    actividad_fill(params[:sub_rubro_id])
    render :update do |page|
      page.replace_html 'actividad-select', :partial => 'actividad_select'
      page.show 'actividad-select'
    end
  end

  def sub_rubro_form_change
    actividad_fill(params[:sub_sector_id])
    render :update do |page|
      page.replace_html 'actividad-select', :partial => 'actividad_form_select'
      page.show 'actividad-select'
    end
  end

  def sub_sector_fill(sector_id)
    @sub_sector_list = SubSector.find(:all, :conditions=>['sector_id = ?', sector_id], :order => 'nombre')
    rubro_fill(0)
    sub_rubro_fill(0)
    actividad_fill(0)
  end

  def rubro_fill(sub_sector_id)
    @rubro_list = Rubro.find(:all, :conditions=>['sub_sector_id = ?', sub_sector_id], :order => 'nombre')
    sub_rubro_fill(0)
    actividad_fill(0)
  end

  def sub_rubro_fill(rubro_id)
    @sub_rubro_list = SubRubro.find(:all, :conditions=>['rubro_id = ?', rubro_id], :order => 'nombre')
    actividad_fill(0)
  end

  def actividad_fill(sub_rubro_id)
    @actividad_list = Actividad.find(:all, :conditions=>['sub_rubro_id = ?', sub_rubro_id], :order => 'nombre')
  end

  def list
    logger.debug "SUBSECTOR :" << params[:sub_sector_id].class.to_s << params[:sector_id].empty?.to_s

    logger.debug "Parametros del list " <<  params[:sector_id].to_s

    params['sort'] = "numero" unless params['sort']
    @oficina_id = session[:oficina]


    @conditions ="estatus_id > 10040 "
    conditions = @conditions


    condition =""


    unless params[:sector_id][0].nil? || params[:sector_id][0].to_s==''
        sector_id = params[:sector_id][0].to_s
        sector = Sector.find(sector_id)
        condition << " and solicitud.sector_id = #{sector_id}"        
    end

    unless params[:sub_sector_id][0].nil? || params[:sub_sector_id][0]==""
        sub_sector_id = params[:sub_sector_id][0].to_s
        subsector = SubSector.find(sub_sector_id)
        condition << " and solicitud.sub_sector_id = #{sub_sector_id}"         
    end  
      
    unless params[:rubro_id][0].nil? || params[:rubro_id][0]==""
        rubro_id = params[:rubro_id][0].to_s
        rubro = Rubro.find(rubro_id)
        condition << " and rubro.id = #{rubro_id}"         
    end  
      
    unless params[:sub_rubro_id][0].nil? || params[:sub_rubro_id][0]==""
        sub_rubro_id = params[:sub_rubro_id][0].to_s
        subrubro = SubRubro.find(sub_rubro_id)
        condition << " and solicitud.sub_rubro_id = #{sub_rubro_id}"         
    end  
      
    unless params[:actividad_id][0].nil? || params[:actividad_id][0]==""
        actividad_id = params[:actividad_id][0].to_s
        actividad = Actividad.find(actividad_id)
        condition << " and solicitud.actividad_id = #{actividad_id}"      
    end  
    
    unless params[:moneda_id][0].blank?
      moneda = Moneda.find(params[:moneda_id][0])
      condition << " AND moneda_id = '#{params[:moneda_id][0].to_i}' "      
    end

    logger.debug "cedula <<<<<<<<<<<<<<<" << params[:identificacion].to_s
    unless params[:identificacion].nil? ||  params[:identificacion].empty?
      conditions += " AND identificacion LIKE  '%#{params[:tipo]+params[:identificacion].strip.downcase}%' "        
    end
    unless params[:numero].nil? || params[:numero].empty?
      conditions += " AND numero_helper =  #{params[:numero].to_i}"        
    end
    unless params[:nombre].nil? || params[:nombre].empty?
      conditions += " AND LOWER(nombre) LIKE  '%#{params[:nombre].strip.downcase}%'"        
    end

    @conditions = conditions.gsub('control=false','control=true')
    @condition = condition
    logger.info"XXXXXXXXXX=========conditions-list============>>>>>>"<<@condition.inspect
    

    sql = "(SELECT solicitud.id, solicitud.numero as numero_helper, CAST(cedula_nacionalidad || ' ' || cedula as varchar) as identificacion,"
    sql += " (primer_nombre || ' ' || primer_apellido) as nombre, fecha_solicitud as fecha, rubro.nombre as rubro, sub_sector.nombre as sub_sector, sub_rubro.nombre as sub_rubro, actividad.nombre as actividad"
    sql += " FROM solicitud INNER JOIN cliente INNER JOIN persona ON cliente.persona_id = persona.id "
    sql += " ON solicitud.cliente_id = cliente.id "
    sql += " INNER JOIN rubro ON solicitud.rubro_id = rubro.id"
    sql += " INNER JOIN sub_rubro ON sub_rubro.id = solicitud.sub_rubro_id"
    sql += " INNER JOIN actividad ON actividad.id = solicitud.actividad_id"
    sql += " INNER JOIN sub_sector ON solicitud.sub_sector_id = sub_sector.id"
    sql += " #{condition} AND oficina_id = #{@oficina_id} UNION SELECT solicitud.id, solicitud.numero as numero_helper, rif as identificacion,"
    sql += " empresa.nombre as nombre, fecha_solicitud as fecha,rubro.nombre as rubro,sub_sector.nombre as sub_sector, sub_rubro.nombre as sub_rubro, actividad.nombre as actividad  FROM solicitud INNER JOIN cliente INNER JOIN empresa "
    sql += " ON cliente.empresa_id = empresa.id ON solicitud.cliente_id = cliente.id "
    sql += " INNER JOIN rubro ON solicitud.rubro_id = rubro.id"
    sql += " INNER JOIN sub_rubro ON sub_rubro.id = solicitud.sub_rubro_id"
    sql += " INNER JOIN actividad ON actividad.id = solicitud.actividad_id"
    sql += " INNER JOIN sub_sector ON solicitud.sub_sector_id = sub_sector.id"
    sql += " #{condition} AND oficina_id = #{@oficina_id}) as solicitud_helper"

    joins = " INNER JOIN #{sql} ON solicitud.id = solicitud_helper.id"

    
    
    
    @list = Solicitud.search_especial(conditions, params[:page], params[:sort], 'solicitud.*', joins)   
    @total=@list.count

    condicion_rol = " usuario_rol.rol_id = 7 " 
    @aux_roles = @usuario.roles.find(:first, :conditions=>condicion_rol)
    
    @comite_ultimo = Comite.find(:first,:order => 'id desc')
    logger.info "CONDICIONES *************************+++++++++++++ "+conditions.inspect
    form_list

  end

  def generate_html(texto,nombre_doc)

    File.open("#{Rails.root}/public/html_pdf/#{nombre_doc}.html", 'w+') do |f1|
      #antes f1.puts Iconv.iconv("ISO-8859-1", "utf-8", texto)
      f1.puts texto.encode('UTF-8')
    end

  end

  def generar
    #GENERACION DE CONTRATO
    if params[:abogado_ofic][:id] == ""
      render :update do |page|
        page.alert I18n.t('Sistema.Body.Vistas.SolicitudConsultoriaJuridica.Mensajes.debe_seleccionar_abogado')
      end
      return
    end
    solic = Solicitud.find_by_id(params[:solicitud_id])
    solic.abogado_id = params[:abogado_ofic][:id]
    #antes estaba esto solic.update
    solic.save
    nro_plantilla = ViewPlantilla.find_by_solicitud_id(params[:solicitud_id])
    if nro_plantilla == nil
      render :update do |page|
        page.alert I18n.t('Sistema.Body.Vistas.SolicitudConsultoriaJuridica.Mensajes.no_existe_planilla')
      end
      return
    end

    @ruta = request.protocol + request.host.to_s + ":" + request.port.to_s

    plantilla = Plantilla.find(nro_plantilla.id)

    @contrato = plantilla.complementar(params[:solicitud_id],session[:oficina],@ruta)

    unless @contrato["ERROR:"].nil?
      render :update do |page|
        page.alert @contrato
      end
      return
    else
      solic.ruta_contrato = imprimir_documento(@contrato, "contrato_" + solic.numero.to_s + "_" + Time.now.strftime("%Y_%m_%d").to_s, "contratos")
      #antes estaba esto solic.update
      solic.save
      sleep 2

      render :update do |page|
        page.replace_html 'content', :partial => 'generar'
        page.show 'content'
      end
    end
  end


  def abogado
    cond="oficina_id = #{session[:oficina]} and activo"
    @list_abogado_ofic = Abogado.find(:all,:conditions=>[cond], :order => 'nombre ASC')
    @solicitud_id_cj = params[:solicitud_id]
    @width_layout = '300'
    render  :layout => 'form_popup'
  end


  def fecha_acta
    @solicitud_id_ae = params[:solicitud_id]
    @fecha = format_fecha(Time.now)
    @width_layout = '500'
    #render  :layout => 'form_popup'
  end

  def acta_entrega
    if params[:fecha_ae].nil? || params[:fecha_ae] == ''
      render :update do |page|
        page.alert "Debe colocar una fecha para el Acta de Entrega"
      end
      return
    end
    solicitud = Solicitud.find_by_id(params[:solicitud_id])
    nro_plantilla = ""
    
    nemo = solicitud.sub_sector.nemonico
    
    if nemo != 'MA'
      if solicitud.cliente.class.to_s == "ClientePersona"
        nro_plantilla = 10
      else
        nro_plantilla = 11
      end
    else
      if solicitud.cliente.class.to_s == "ClientePersona"
        nro_plantilla = 30
      else
        nro_plantilla = 31
      end
    end

    @ruta = request.protocol + request.host.to_s + ":" + request.port.to_s

    plantilla = Plantilla.find(nro_plantilla)
    plantilla.setFechaActa(params[:fecha_ae])
    @acta_entrega = plantilla.complementar(params[:solicitud_id],session[:oficina],@ruta)

    solicitud.ruta_acta_entrega = imprimir_documento(@acta_entrega, "acta_entrega_" + solicitud.numero.to_s + "_" + Time.now.strftime("%Y_%m_%d").to_s, "actas_entregas")

      

    fecha_ae=format_fecha_conversion(params[:fecha_ae])
    #fecha_ae = params[:fecha_ae].slice(6,4).to_s + "-" + params[:fecha_ae].slice(3,2).to_s + "-" + params[:fecha_ae].slice(0,2).to_s

    solicitud.fecha_a_entrega = fecha_ae
    solicitud.save
    sleep 2

    render :update do |page|
      page.replace_html 'content', :partial => 'generar'
      page.show 'content'
    end

  end

  def sras
    @solicitud = Solicitud.find(params[:solicitud_id])
    if @solicitud.codigo_sras == nil || @solicitud.codigo_sras == 0
      parametro_gen = ParametroGeneral.find(1)
      parametro_gen.codigo_seg += 1
      @solicitud.codigo_sras = parametro_gen.codigo_seg
      #antes estaba esto parametro_gen.update
      parametro_gen.save
      #antes estaba esto @solicitud.update
      @solicitud.save
    end
    @view_solicitud = ViewSolicitud.find_by_solicitud_id(params[:solicitud_id])
    @udp = ViewUnidadProduccion.find_by_solicitud_id(params[:solicitud_id])
    @prestamo = Prestamo.find_by_solicitud_id(params[:solicitud_id])

    render :partial => 'sras'
  end

  def condiciones
    solicitud = Solicitud.find(params[:solicitud_id])

    sector = solicitud.sector.nombre.downcase.gsub(' ', '_')
    @ruta = request.protocol + request.host.to_s + ":" + request.port.to_s

    @archivo = @ruta << "/condiciones_sras/condiciones_#{sector}.html"

    sleep 2
    render :partial => 'generar'

  end
  
  def print_acta_entrega

    @archivo = Solicitud.find(params[:solicitud_id]).ruta_acta_entrega

    sleep 2
    render :partial => 'generar'

  end


  def generar_NA

    #GENERACION DE NOTA DE AUTENTICACION
    if params[:abogado_ofic][:id] == ""
      render :update do |page|
        page.alert I18n.t('Sistema.Body.Vistas.SolicitudConsultoriaJuridica.Mensajes.debe_seleccionar_abogado')
      end
      return
    end
    @testigos = SolicitudTestigos.find_by_sql("select * from solicitud_testigos where solicitud_id =#{params[:solicitud_id]} order by id limit 3")
    if @testigos.empty?
      render :update do |page|
        page.alert I18n.t('Sistema.Body.Vistas.SolicitudConsultoriaJuridica.Mensajes.agregar_testigos')
      end
      return
    elsif @testigos.size < 2
      render :update do |page|
        page.alert I18n.t('Sistema.Body.Vistas.SolicitudConsultoriaJuridica.Mensajes.debe_agregar_testigos')
      end
      return   end
    logger.debug "CANTIDAD DE TESTIGOS " << @testigos.inspect
    solicitud = Solicitud.find_by_id(params[:solicitud_id])
    if solicitud.ruta_contrato.nil?
      render :update do |page|
        page.alert I18n.t('Sistema.Body.Vistas.SolicitudConsultoriaJuridica.Mensajes.debe_generar_contrato_antes_n_a')
      end
      return
    end
    solicitud.abogado_id = params[:abogado_ofic][:id]
    solicitud.fecha_nota_autenticacion = Time.now
    #antes solicitud.update
    solicitud.save
    if solicitud.tomo_autenticacion == nil || solicitud.tomo_autenticacion == ''
      ofic = Oficina.find_by_id(solicitud.oficina_id)
      if ofic.folio_autenticacion == 65
        ofic.tomo_autenticacion+=1
        ofic.folio_autenticacion=1
      else
        ofic.folio_autenticacion+=1
      end
      #antes ofic.update
      ofic.save
      solicitud.tomo_autenticacion = ofic.tomo_autenticacion
      solicitud.folio_autenticacion = ofic.folio_autenticacion
      #antes solicitud.update
      solicitud.save
    end
    nro_plantilla = ""
    if solicitud.cliente.class.to_s == "ClientePersona"
      nro_plantilla = 1
    else
      nro_plantilla = 9
    end

    @ruta = request.protocol + request.host.to_s + ":" + request.port.to_s

    plantilla = Plantilla.find(nro_plantilla)

    @nota_autentica = plantilla.complementar_NA(params[:solicitud_id],@testigos,session[:oficina],@ruta)

    solicitud.ruta_nota_autenticacion = imprimir_documento(@nota_autentica, "nota_autenticacion_" + solicitud.numero.to_s + "_" + Time.now.strftime("%Y_%m_%d").to_s, "notas_autenticacion")
    #antes solicitud.update
    solicitud.save

    render :update do |page|
      page.replace_html 'content', :partial => 'generar'
      page.show 'content'
    end
    
  end

  def imprimir_documento(texto_plantilla,nombre_doc,carpeta)

    #GUARDAR EL TEXTO HTML EN UN DOCUMENTO .HTML PARA SER CONVERTIDO EN PDF
    generate_html(texto_plantilla,nombre_doc)

    @parametro_general = ParametroGeneral.find(1)
    cadena = "htmldoc -t pdf -f \"public/#{carpeta}/#{nombre_doc}.pdf\" --webpage --no-title --linkstyle underline --footer '...' --size Legal --left #{@parametro_general.margen_izquierdo.to_s + "cm"} --right #{@parametro_general.margen_derecho.to_s + "cm"} --top #{@parametro_general.margen_superior.to_s + "cm"} --bottom #{@parametro_general.margen_inferior.to_s + "cm"} --fontsize #{@parametro_general.tamano_fuente.to_s} --fontspacing #{@parametro_general.interlineado.to_s} --portrait --color --no-pscommands --no-xrxcomments --compression=1 --textfont Courier --charset utf-8 --links --embedfonts --pagemode document --pagelayout single --firstpage p1 --no-encryption --permissions all --no-strict --no-overflow  " << request.protocol << request.host.to_s << ":" << request.port.to_s << "/html_pdf/#{nombre_doc}.html"
    IO.popen(cadena)

    @ruta = request.protocol + request.host.to_s + ":" + request.port.to_s

    @archivo = @ruta << "/#{carpeta}/#{nombre_doc}.pdf"
      
  end


  def suscribir
    solicitud = Solicitud.find(params[:solicitud_id])
    condicion =
      solicitud_sus = SolicitudContrato.find(:first, :conditions => ['solicitud_id = ?',params[:solicitud_id]], :order => 'id desc')
    @solicitud_id_sus = params[:solicitud_id]
    unless solicitud_sus.nil?
	    @fecha_rc = format_fecha(solicitud_sus.fecha_recepcion)
	    @fecha_nt = format_fecha(solicitud_sus.fecha_notaria)
	    #@fecha_rg = solicitud_sus.fecha_registro.strftime("%d/%m/%Y")
    else
	    @fecha_rc = ""
	    @fecha_nt = format_fecha(solicitud.fecha_nota_autenticacion) unless solicitud.fecha_nota_autenticacion.nil?
	    #@fecha_rg = ""
    end
    @width_layout = '450'
  end

  def save_suscribir
    if params[:fecha_rc] == "" || params[:fecha_nt] == ""
      render :update do |page|
        page.alert I18n.t('Sistema.Body.Vistas.SolicitudConsultoriaJuridica.Mensajes.datos_incompletos')
      end
      return
    end
    @solicitud = Solicitud.find(params[:solicitud_id])
    @solicitud_contrato = SolicitudContrato.new
    @solicitud_contrato.solicitud_id = params[:solicitud_id]
    @solicitud_contrato.nombre_archivo = @solicitud.ruta_contrato
    @solicitud_contrato.fecha_recepcion = params[:fecha_rc]
    @solicitud_contrato.fecha_notaria = format_fecha(@solicitud.fecha_nota_autenticacion) unless @solicitud.fecha_nota_autenticacion.nil?
    #@solicitud_contrato.fecha_registro = (params[:fecha_rg].nil? ? '' : params[:fecha_rg])
    unless @solicitud_contrato.save

      render :update do |page|
        page.hide 'message'
        page.form_error
      end
      return
    else
      render :update do |page|
        page.hide 'message'
        page.hide 'error'
        page.alert "#{I18n.t('Sistema.Body.Vistas.SolicitudConsultoriaJuridica.Mensajes.se_suscribio_satisfactoriamente')} #{@solicitud.numero}"
      end
      return
    end
  end

  protected
  def common
    super
    @form_title = I18n.t('Sistema.Body.Vistas.SolicitudConsultoriaJuridica.Header.form_title')
    @form_title_record = I18n.t('Sistema.Body.Vistas.SolicitudConsultoriaJuridica.Header.form_title_record')
    @form_title_records = I18n.t('Sistema.Body.Vistas.SolicitudConsultoriaJuridica.Header.form_title_records')
    @form_entity = 'solicitud'
    @form_identity_field = 'numero'
    @width_layout = '1160'
  end 

end

