# encoding: utf-8
require 'rubygems'
require 'roo'
String#encode = 'u'

class Solicitudes::GestionarGarantiaController < FormTabsController

  layout 'form_basic'
 
  skip_before_filter :set_charset, :only=>[:tabs, :editar_mobiliaria, :edit_informe, :new, :cancel_new, :save_new_informe, :save_informe_new, 
    :save_informe_edit, :save_new_semoviente, :delete_semoviente, :delete_imagen, :constituir, :save_constitucion_new, 
    :save_constitucion_edit, :avanzar, :ubicacion, :etiqueta_folio, :estado_change, :municipio_change, :estado_list, :view_detail, :delete_mobiliaria, 
    :save_archivo, :save_new_mobiliaria1, :save_new_mobiliaria2, :view_constitucion]

  def index
    @estado = Estado.find(:all, :order => 'nombre')
    @sector_economico = SectorEconomico.find(:all, :order=>'descripcion')
    @moneda_list = Moneda.find(:all, :conditions=> "activo = true", :order => "nombre")
  end

  def editar_mobiliaria
    @mobiliario = SolicitudAvaluoMobiliarioTipos.find(:first, :conditions=>["ubicacion = 'D' and id= ?", params[:id]])
    render :update do |page|
      page.hide 'errorExplanation'
      page.replace_html 'mobiliaria', :partial => 'mobiliaria_editar_tipo_mobiliario'
      page.replace_html 'documento', :partial => 'mobiliaria_editar_tipo_documento'
      page.show 'mobiliaria'
      page.show 'documento'
      page.show 'message'
      page.<< "window.scrollTo(0,200);"
    end
  end



  def list
    @condition ="estatus_id in (10004, 10005, 10010, 10031, 10033, 10034) and confirmacion = true"
    params['sort'] = "numero" unless params['sort']
    unless params[:numero].nil? || params[:numero].empty?
      @condition << " AND numero =  #{params[:numero].to_i}"
      @form_search_expression << "Número de Solicitud igual '#{params[:numero]}'"
    end

    unless params[:numero_prestamo].to_s.nil? || params[:numero_prestamo].to_s.empty?
      @condition << " AND financiamiento = #{params[:numero_prestamo]}"
      @form_search_expression << "Número de Financiamiento igual '#{params[:numero_prestamo]}'"
    end

    unless params[:identificacion].nil? ||  params[:identificacion].empty?
      @condition << " AND UPPER(cedula_rif) LIKE UPPER('%#{params[:identificacion].strip}%') "
      @form_search_expression << "Rif o Cédula contenga '#{params[:identificacion]}'"
    end

    unless params[:nombre].nil? || params[:nombre].empty?
      @condition << " AND UPPER(nombre) LIKE UPPER('%#{params[:nombre].strip}%')"
      @form_search_expression << "Beneficiario '#{params[:nombre]}'"
    end
    
    if params[:moneda_id][0].blank?
      parametro = ParametroGeneral.find(:first)
      moneda = Moneda.find(parametro.moneda_id.to_s)
      @condition << " AND moneda_id = '#{parametro.moneda_id.to_s}' "      
      @form_search_expression << "#{I18n.t('Sistema.Body.Vistas.General.moneda')} #{I18n.t('Sistema.Body.Vistas.General.igual')} '#{moneda.nombre}'"
    else
      moneda = Moneda.find(params[:moneda_id][0])
      @condition << " AND moneda_id = '#{params[:moneda_id][0].to_i}' "      
      @form_search_expression << "#{I18n.t('Sistema.Body.Vistas.General.moneda')} #{I18n.t('Sistema.Body.Vistas.General.igual')} '#{moneda.nombre}'"
    end

    @list = ViewGestionarGarantias.search(@condition, params[:page], params[:sort])
    @total=@list.count
    form_list
  end

  def edit
    @solicitud = Solicitud.find(params[:id])
    @solicitud_tipo_garantia = SolicitudTipoGarantia.find(:all, :conditions=>['solicitud_id = ?', @solicitud.id])
  end

  def edit_informe
    total = SolicitudAvaluo.count(:conditions=>['solicitud_id = ? and solicitud_tipo_garantia_id = ?',params[:solicitud_id], params[:id]])
    solicitud_tipo_garantia = SolicitudTipoGarantia.find(params[:id])
    @solicitud_tipo_garantia_id = solicitud_tipo_garantia.id
    @relacion = solicitud_tipo_garantia.relacion_garantia
    logger.info"XXXXXXXXXXXXXXXXXXXXXXX-relacion_garantia-XXXXXXXXXXXXXXXX"<<@relacion.inspect
    @estatus = solicitud_tipo_garantia.estatus
    @solicitud = Solicitud.find(params[:solicitud_id])
    @solicitud_avaluo_imagen = SolicitudAvaluoImagen.find(:all,:conditions=>['solicitud_tipo_garantia_id = ?', @solicitud_tipo_garantia_id])
    if total > 0
      @solicitud_avaluo = SolicitudAvaluo.find(:first, :conditions=>["solicitud_tipo_garantia_id = ? and estatus = 'V'",params[:id]])
      @editar = 1 #no se usa
      @metodo = 'save_informe_edit'
    else
      @solicitud_avaluo = SolicitudAvaluo.new
      @editar = 0 #no se usa
      @metodo = 'save_informe_new'
    end
    if solicitud_tipo_garantia.tipo_garantia.tipo == "M"
      @rhtml = "mobiliaria"
      @solicitud_avaluo_mobiliario = SolicitudAvaluoMobiliario.new
      @mobiliario_tipos_mobiliario_list = SolicitudAvaluoMobiliarioTipos.find(:all, :conditions=>["ubicacion = 'M' and solicitud_tipo_garantia_id = ?", params[:id]])
      @mobiliario_tipos_documento_list = SolicitudAvaluoMobiliarioTipos.find(:all, :conditions=>["ubicacion = 'D' and solicitud_tipo_garantia_id = ?", params[:id]])
      if total > 0 && SolicitudAvaluoMobiliario.count(:conditions=>['solicitud_avaluo_id = ? ', @solicitud_avaluo.id]) > 0
        @solicitud_avaluo_mobiliario = SolicitudAvaluoMobiliario.find(:first, :conditions=>['solicitud_avaluo_id = ? ', @solicitud_avaluo.id])
      end
    elsif solicitud_tipo_garantia.tipo_garantia.tipo == 'I'
      @rhtml = "inmobiliaria"
      if total > 0 && SolicitudAvaluoInmobiliario.count(:conditions=>['solicitud_avaluo_id = ? ', @solicitud_avaluo.id]) > 0
        @solicitud_avaluo_inmobiliario = SolicitudAvaluoInmobiliario.find(:first, :conditions=>['solicitud_avaluo_id = ? ', @solicitud_avaluo.id])
      else
        @solicitud_avaluo_inmobiliario = SolicitudAvaluoInmobiliario.new
        @solicitud_avaluo_inmobiliario.clasificacion = 'T'
      end
    elsif solicitud_tipo_garantia.tipo_garantia.tipo == 'P'
      @rhtml = "prenda"
      @semoviente_list = TiposSemovientes.find(:all, :order=>'nombre')
      @prenda_semoviente_list = SolicitudAvaluoPrendaSemoviente.find(:all, :conditions=>['solicitud_tipo_garantia_id = ?', params[:id]])
      if total > 0 && SolicitudAvaluoPrenda.count(:conditions=>['solicitud_avaluo_id = ? ', @solicitud_avaluo.id]) > 0
        @solicitud_avaluo_prenda = SolicitudAvaluoPrenda.find(:first, :conditions=>['solicitud_avaluo_id = ? ', @solicitud_avaluo.id])
      else
        @solicitud_avaluo_prenda = SolicitudAvaluoPrenda.new
      end
    elsif solicitud_tipo_garantia.tipo_garantia.tipo == 'F'
      @rhtml  = "fianza"
      @solicitud_avaluo_fianza = SolicitudAvaluoFianza.new
      if total > 0 && SolicitudAvaluoFianza.count(:conditions=>['solicitud_avaluo_id = ? ', @solicitud_avaluo.id]) > 0
        @solicitud_avaluo_fianza = SolicitudAvaluoFianza.find(:first, :conditions=>['solicitud_avaluo_id = ? ', @solicitud_avaluo.id])
      end
      @nacionalidad_select = Nacionalidad.find_by_sql("select id, masculino as descripcion from nacionalidad" )
    end
    @estado_select = Estado.find(:all, :order=>'nombre')
    if @solicitud_avaluo.estado.nil?
      estado_id = @estado_select.first.id
    else
      estado_id = @solicitud_avaluo.estado.id
    end
    municipio_fill(estado_id)
  end

  def new
    @solicitud = Solicitud.find(params[:id])
    @tipo_garantia_list =ProgramaTipoGarantia.joins('JOIN tipo_garantia ON tipo_garantia.id = programa_tipo_garantia.tipo_garantia_id').where("programa_tipo_garantia.programa_id = #{@solicitud.programa_id} and tipo_garantia.activo = true")
    logger.info"XXXXXXX=========ppp=========>>>>>"<<@tipo_garantia_list.inspect
    #@tipo_garantia_list = TipoGarantia.find(:all, :conditions=>['activo = true and id in (select tipo_garantia_id from programa_tipo_garantia where programa_id = ?)',@solicitud.programa.id])
    render :update do |page|
      page.hide 'message'
      page.hide 'error'
      page.replace_html 'boton_new', :partial => 'new'
      page.show 'boton_new'
    end
  end

  def save_new_informe
    @solicitud = Solicitud.find(params[:solicitud_id])
    dato = params[:solicitud_tipo_garantia][:tipo_garantia_id].to_s.split('..')
    resultado = SolicitudTipoGarantia.crear_registro(dato, @solicitud.id)
    if resultado == true
      @solicitud_tipo_garantia = SolicitudTipoGarantia.find(:all, :conditions=>['solicitud_id = ?', @solicitud.id])
      render :update do |page|
        page.hide 'error'
        page.replace_html 'list', :partial => 'list_garantia'
        page.replace_html 'boton_new', :partial => 'boton_agregar'
        page.replace_html 'message', I18n.t('Sistema.Body.Vistas.GestionarGarantia.Mensajes.tipo_garantia_se_guardo_con_exito')
        page.show 'boton_new'
        page.show 'list'
        page.show 'message'
        page.<< "varEnviado = true;"
      end
    else
      render :update do |page|
        page.hide 'message'
        page.hide 'error'
        page.replace_html 'errorExplanation',"<h2>#{I18n.t('Sistema.Body.General.ocurrio_error')}</h2><p><UL>" << resultado << "</UL></p>"
        page.show 'errorExplanation'
        page.<< "varEnviado = false;"
        page.<< "window.scrollTo(0,0);"
      end
    end
  end

  def save_informe_new
    solicitud_tipo_garantia = SolicitudTipoGarantia.find(params[:solicitud_tipo_garantia_id])
    if solicitud_tipo_garantia.tipo_garantia.tipo == 'M'
      parametros = params[:solicitud_avaluo_mobiliario]
    elsif solicitud_tipo_garantia.tipo_garantia.tipo == 'I'
      parametros = params[:solicitud_avaluo_inmobiliario]
    elsif solicitud_tipo_garantia.tipo_garantia.tipo == 'F'
      parametros = params[:solicitud_avaluo_fianza]
    elsif solicitud_tipo_garantia.tipo_garantia.tipo == 'P'
      parametros = params[:solicitud_avaluo_prenda]
    end
    errores = SolicitudAvaluo.crear_registro(params[:solicitud_avaluo], parametros, params[:solicitud_id], params[:solicitud_tipo_garantia_id])
    if errores == true
      flash[:notice] = I18n.t('Sistema.Body.Vistas.GestionarGarantia.Mensajes.garantia_se_guardo_con_exito')
      render :update do |page|
        new_options = {:action=>'edit_informe', :id=>params[:solicitud_tipo_garantia_id], :solicitud_id=>params[:solicitud_id] }
        page.redirect_to new_options
      end
    else
      render :update do |page|
        page.hide 'message'
        page.replace_html 'errorExplanation',"<h2>#{I18n.t('Sistema.Body.General.ocurrio_error')}</h2><p><UL>" << errores << '</UL></p>'
        page.show 'errorExplanation'
        page.<< "varEnviado = false;"
        page.<< "window.scrollTo(0,0);"
      end
    end
  end

  def save_informe_edit
    solicitud_avaluo = SolicitudAvaluo.find(params[:id])
    if solicitud_avaluo.solicitud_tipo_garantia.tipo_garantia.tipo == 'M'
      parametros = params[:solicitud_avaluo_mobiliario]
    elsif solicitud_avaluo.solicitud_tipo_garantia.tipo_garantia.tipo == 'I'
      parametros = params[:solicitud_avaluo_inmobiliario]
    elsif solicitud_avaluo.solicitud_tipo_garantia.tipo_garantia.tipo == 'F'
      parametros = params[:solicitud_avaluo_fianza]
    elsif solicitud_avaluo.solicitud_tipo_garantia.tipo_garantia.tipo == 'P'
      parametros = params[:solicitud_avaluo_prenda]
    end
    errores = SolicitudAvaluo.historico_registro(params[:solicitud_avaluo], parametros, params[:id])
    if errores == true
      solicitud_avaluo = SolicitudAvaluo.find(params[:id])
      flash[:notice] = I18n.t('Sistema.Body.Vistas.GestionarGarantia.Mensajes.garantia_se_guardo_con_exito')
      render :update do |page|
        new_options = {:action=>'edit_informe', :id=>solicitud_avaluo.solicitud_tipo_garantia_id, :solicitud_id=>solicitud_avaluo.solicitud_id }
        page.redirect_to new_options
      end
    else
      render :update do |page|
        page.hide 'message'
        page.replace_html 'errorExplanation',"<h2>#{I18n.t('Sistema.Body.General.ocurrio_error')}</h2><p><UL>" << errores << '</UL></p>'
        page.show 'errorExplanation'
        page.<< "varEnviado = false;"
        page.<< "window.scrollTo(0,0);"
      end
    end
  end
  
  #
  def save_new_mobiliaria1
    errores = SolicitudAvaluoMobiliarioTipos.create_new(params[:solicitud_avaluo_mobiliario_tipos], params[:solicitud_tipo_garantia_id])
    if errores == true
      @mobiliario_tipos_mobiliario_list = SolicitudAvaluoMobiliarioTipos.find(:all, :conditions=>["ubicacion = 'M' and solicitud_tipo_garantia_id = ?", params[:solicitud_tipo_garantia_id]])
      render :update do |page|
        page.hide 'errorExplanation'
        page.replace_html 'mobiliaria', :partial => 'mobiliaria_tipo_mobiliario'
        page.replace_html 'message', I18n.t('Sistema.Body.Vistas.GestionarGarantia.Mensajes.datos_mobiliaria_se_guardo_con_exito')
        page.show 'mobiliaria'
        page.show 'message'
        page.<< "window.scrollTo(0,200);"
      end
    else
      render :update do |page|
        page.hide 'message'
        page.replace_html 'errorExplanation',"<h2>#{I18n.t('Sistema.Body.General.ocurrio_error')}</h2><p><UL>" << errores << '</UL></p>'
        page.show 'errorExplanation'
        page.<< "varEnviado = false;"
        page.<< "window.scrollTo(0,200);document.getElementById('agregar-mobiliario-tipo').style.display= '';"
      end
    end
  end


  def save_new_mobiliaria2
    errores = SolicitudAvaluoMobiliarioTipos.create_new(params[:solicitud_avaluo_mobiliario_tipos], params[:solicitud_tipo_garantia_id])
    if errores == true
      @mobiliario_tipos_documento_list = SolicitudAvaluoMobiliarioTipos.find(:all, :conditions=>["ubicacion = 'D' and solicitud_tipo_garantia_id = ?", params[:solicitud_tipo_garantia_id]])
      render :update do |page|
        page.hide 'errorExplanation'
        page.replace_html 'documento', :partial => 'mobiliaria_tipo_documento'
        page.replace_html 'message', I18n.t('Sistema.Body.Vistas.GestionarGarantia.Mensajes.datos_mobiliaria_se_guardo_con_exito')
        page.show 'documento'
        page.show 'message'
        page.<< "window.scrollTo(0,200);"
      end
    else
      render :update do |page|
        page.hide 'message'
        page.replace_html 'errorExplanation',"<h2>#{I18n.t('Sistema.Body.General.ocurrio_error')}</h2><p><UL>" << errores << '</UL></p>'
        page.show 'errorExplanation'
        page.<< "varEnviado = false;"
        page.<< "window.scrollTo(0,200);document.getElementById('agregar-tipo-documento').style.display= '';"
      end
    end
  end

  def update_mobiliaria
    solicitud                   = SolicitudAvaluoMobiliarioTipos.find(params[:solicitud_avaluo_mobiliario_tipos][:mobiliaria_id])
    solicitud.tipo              = params[:solicitud_avaluo_mobiliario_tipos][:tipo]
    solicitud.modelo            = params[:solicitud_avaluo_mobiliario_tipos][:modelo]
    solicitud.marca             = params[:solicitud_avaluo_mobiliario_tipos][:marca]
    solicitud.serial            = params[:solicitud_avaluo_mobiliario_tipos][:serial]
    solicitud.hipoteca          = params[:solicitud_avaluo_mobiliario_tipos][:hipoteca_f]
    solicitud.ubicacion         = params[:solicitud_avaluo_mobiliario_tipos][:ubicacion]
    solicitud.solicitud_tipo_garantia_id = params[:solicitud_tipo_garantia_id]
    solicitud.save
    @mobiliario_tipos_mobiliario_list = SolicitudAvaluoMobiliarioTipos.find(:all, :conditions=>["ubicacion = 'M' and solicitud_tipo_garantia_id = ?", params[:solicitud_tipo_garantia_id]])
    @mobiliario_tipos_documento_list  = SolicitudAvaluoMobiliarioTipos.find(:all, :conditions=>["ubicacion = 'D' and solicitud_tipo_garantia_id = ?", params[:solicitud_tipo_garantia_id]])
    render :update do |page|
      @rhtml = "mobiliaria"
      @solicitud_avaluo_mobiliario = SolicitudAvaluoMobiliario.new
      page.hide 'errorExplanation'
      page.replace_html 'mobiliaria', :partial => 'mobiliaria_tipo_mobiliario'
      page.replace_html 'documento', :partial => 'mobiliaria_tipo_documento'
      page.replace_html 'message', I18n.t('Sistema.Body.Vistas.GestionarGarantia.Mensajes.se_actualizo_el_registro')
      page.show 'mobiliaria'
      page.show 'message'
    end
  end


  def delete_mobiliaria
    @rhtml = "mobiliaria"
    @solicitud_avaluo_mobiliario = SolicitudAvaluoMobiliario.new
    SolicitudAvaluoMobiliarioTipos.delete_registro(params[:id])
    
    if params[:ubicacion] == 'M'
      render :update do |page|
        page.hide 'errorExplanation'
        page.remove "mob_#{params[:id]}"
        page.replace_html 'message', I18n.t('Sistema.Body.Modelos.BoletaArrime.Messages.se_elimino_con_exito')
        page.show 'message'
        page.<< "window.scrollTo(0,200);"
      end
    else
      render :update do |page|
        page.hide 'errorExplanation'
        page.remove "mob_doc_#{params[:id]}"
        page.replace_html 'message', I18n.t('Sistema.Body.Modelos.BoletaArrime.Messages.se_elimino_con_exito')
        page.show 'message'
        page.<< "window.scrollTo(0,200);"
      end
    end
  end

  
  #
  
  def save_new_semoviente
    errores = SolicitudAvaluoPrendaSemoviente.create_new(params[:solicitud_avaluo_prenda_semoviente], params[:solicitud_tipo_garantia_id])
    solicitud_id = SolicitudTipoGarantia.select("solicitud_id").where("id = #{params[:solicitud_tipo_garantia_id]}")
    logger.info"XXXXXXXXXXXX-SOLICITUD-ID-XXXXXXX"<<solicitud_id[0].solicitud_id.inspect
    @solicitud = Solicitud.find(solicitud_id[0].solicitud_id.to_s)
    if errores == true
      @prenda_semoviente_list = SolicitudAvaluoPrendaSemoviente.find(:all, :conditions=>['solicitud_tipo_garantia_id = ?', params[:solicitud_tipo_garantia_id]])
      @semoviente_list = TiposSemovientes.find(:all, :order=>'nombre')
      render :update do |page|
        page.hide 'errorExplanation'
        page.replace_html 'semovientes', :partial => 'prenda_semoviente'
        page.replace_html 'message', I18n.t('Sistema.Body.Vistas.GestionarGarantia.Mensajes.datos_semoviente_se_guardo_con_exito')
        page.show 'semovientes'
        page.show 'message'
        page.<< "window.scrollTo(0,200);"
      end
    else
      render :update do |page|
        page.hide 'message'
        page.replace_html 'errorExplanation',"<h2>#{I18n.t('Sistema.Body.General.ocurrio_error')}</h2><p><UL>" << errores << '</UL></p>'
        page.show 'errorExplanation'
        page.<< "window.scrollTo(0,0);document.getElementById('agregar').style.display= '';"
      end
    end
  end

  def delete_semoviente
    SolicitudAvaluoPrendaSemoviente.delete_registro(params[:id])
    @prenda_semoviente_list = SolicitudAvaluoPrendaSemoviente.find(:all, :conditions=>['solicitud_tipo_garantia_id = ?', params[:solicitud_tipo_garantia_id]])
    solicitud_id = SolicitudTipoGarantia.select("solicitud_id").where("id = #{params[:solicitud_tipo_garantia_id]}")
    @solicitud = Solicitud.find(solicitud_id[0].solicitud_id.to_s)
    @semoviente_list = TiposSemovientes.find(:all, :order=>'nombre')
    render :update do |page|
      page.hide 'errorExplanation'
      page.replace_html 'semovientes', :partial => 'prenda_semoviente'
      page.replace_html 'message', I18n.t('Sistema.Body.Modelos.BoletaArrime.Messages.se_elimino_con_exito')
      page.show 'semovientes'
      page.show 'message'
      page.<< "window.scrollTo(0,200);"
    end
  end


  def delete_imagen
    @solicitud_tipo_garantia_id = borrar_imagen(params[:id])
    solicitud_tipo_garantia = SolicitudTipoGarantia.find(@solicitud_tipo_garantia_id)
    @solicitud = Solicitud.find(solicitud_tipo_garantia.solicitud_id)
    @solicitud_avaluo_imagen = SolicitudAvaluoImagen.find(:all,:conditions=>['solicitud_tipo_garantia_id = ?', @solicitud_tipo_garantia_id])
    render :update do |page|
      page.hide 'errorExplanation'
      page.replace_html 'archivo-imagen', :partial => 'archivo'
      page.replace_html 'message', I18n.t('Sistema.Body.Modelos.BoletaArrime.Messages.se_elimino_con_exito')
      page.show 'archivo'
      page.show 'message'
      page.<< "window.scrollTo(0,200);"
    end
  end

  def constituir
    @solicitud_tipo_garantia = SolicitudTipoGarantia.find(params[:id])
    @solicitud = Solicitud.find(params[:solicitud_id])
    @indice = SolicitudTipoGarantia.indice_garantia(@solicitud_tipo_garantia.relacion_garantia, @solicitud.monto_solicitado)
    referencia = SolicitudTipoGarantia.get_valor(@solicitud.id)
    @valor_referencia = referencia[0]
    @total_referencia = referencia[1]
    if SolicitudConstitucionGarantia.count(:conditions=>['solicitud_tipo_garantia_id = ?', @solicitud_tipo_garantia.id]) > 0
      @solicitud_constitucion_garantia = SolicitudConstitucionGarantia.find(:first, :conditions=>['solicitud_tipo_garantia_id = ?', @solicitud_tipo_garantia.id])
      @editar = 1
      @metodo = 'save_constitucion_edit'
    else
      @solicitud_constitucion_garantia = SolicitudConstitucionGarantia.new
      @editar = 0
      @metodo = 'save_constitucion_new'
    end
    @estado_select = Estado.find(:all, :order=>'nombre')
    if @solicitud_constitucion_garantia.estado.nil?
      estado_id = @estado_select.first.id
    else
      estado_id = @solicitud_constitucion_garantia.estado.id
    end
    municipio_fill(estado_id)
  end

  def save_constitucion_new
    errores = SolicitudConstitucionGarantia.crear_registro(params[:solicitud_constitucion_garantia], params[:solicitud_tipo_garantia_id])
    if errores == true
      flash[:notice] =  I18n.t('Sistema.Body.Vistas.GestionarGarantia.Mensajes.datos_constitucion_se_guardo_con_exito')
      render :update do |page|
        new_options = {:action=>'constituir', :id=>params[:solicitud_tipo_garantia_id], :solicitud_id=>params[:solicitud_id] }
        page.redirect_to new_options
      end
    else
      render :update do |page|
        page.hide 'message'
        page.replace_html 'errorExplanation',"<h2>#{I18n.t('Sistema.Body.General.ocurrio_error')}</h2><p><UL>" << errores << '</UL></p>'
        page.show 'errorExplanation'
        page.<< "window.scrollTo(0,0);"
      end
    end
  end

  def save_constitucion_edit
    solicitud_tipo_garantia = SolicitudTipoGarantia.find(params[:id])
    errores = SolicitudConstitucionGarantia.editar_registro(params[:solicitud_constitucion_garantia], solicitud_tipo_garantia.id)
    if errores == true
      flash[:notice] = I18n.t('Sistema.Body.Vistas.GestionarGarantia.Mensajes.datos_constitucion_se_guardo_con_exito')
      render :update do |page|
        new_options = {:action=>'constituir', :id=>solicitud_tipo_garantia.id, :solicitud_id=>solicitud_tipo_garantia.solicitud_id }
        page.redirect_to new_options
      end
    else
      render :update do |page|
        page.hide 'message'
        page.replace_html 'errorExplanation',"<h2>#{I18n.t('Sistema.Body.General.ocurrio_error')}</h2><p><UL>" << errores << '</UL></p>'
        page.show 'errorExplanation'
        page.<< "window.scrollTo(0,0);"
      end
    end
  end

  def avanzar
    @solicitud_tipo_garantia = SolicitudTipoGarantia.find(params[:id])
    @solicitud = Solicitud.find(@solicitud_tipo_garantia.solicitud_id)
    @solicitud_tipo_garantia.constituir()
    logger.info"XXXXX===========count============"<<@solicitud_tipo_garantia.errors.count.inspect
    if (@solicitud_tipo_garantia.errors.count.nil? || @solicitud_tipo_garantia.errors.count == 0)
      @solicitud_tipo_garantia.estatus = 'C'
      @solicitud_tipo_garantia.save
      @solicitud_tipo_garantia = SolicitudTipoGarantia.find(:all, :conditions=>['solicitud_id = ?', @solicitud.id])
      render :update do |page|
        page.hide 'error'
        page.replace_html 'list', :partial => 'list_garantia'
        page.replace_html 'message', I18n.t('Sistema.Body.Vistas.GestionarGarantia.Mensajes.se_constituyo_con_exito')
        page.show 'list'
        page.show 'message'
      end
    else
      render :update do |page|
        page.form_error
      end
      return
    end
  end

  def ubicacion
    unless params[:solicitud_avaluo_id].nil?
      @solicitud_avaluo = SolicitudAvaluo.find(params[:solicitud_avaluo_id])
    else
      @solicitud_avaluo = SolicitudAvaluo.new
    end
    unless params[:id].to_i == 3
      @solicitud_id = params[:solicitud_id]
      @solicitud = Solicitud.find(@solicitud_id)
      @cliente = Cliente.find(@solicitud.cliente_id)
      if @cliente.type.to_s == "ClienteEmpresa"
        if params[:id].to_i == 1
          @direccion = EmpresaDireccion.find(:first, :conditions=>["empresa_id = ? and tipo = 'P'", @cliente.empresa_id])
        else
          @direccion = UnidadProduccion.find(:first, :conditions=>["id = #{@solicitud.unidad_produccion_id}"])
        end
      else
        if params[:id].to_i == 1
          @direccion = PersonaDireccion.find(:first, :conditions=>["persona_id = ?", @cliente.persona_id])
        else
          @direccion = UnidadProduccion.find(:first, :conditions=>["id = #{@solicitud.unidad_produccion_id}"])
        end
      end
      if @direccion.nil?
        if params[:id].to_i == 1
          mensaje = I18n.t('Sistema.Body.Vistas.GestionarGarantia.Mensajes.no_posee_ubicacion_principal')
        else
          mensaje = I18n.t('Sistema.Body.Vistas.GestionarGarantia.Mensajes.no_posee_ubicacion_negocio')
        end
        render :update do |page|
          page.alert mensaje
        end
        return
      else
        render :update do |page|
          page.replace_html 'direccion-select', :partial=>'direccion_final_select'
          page.show 'direccion-select'
          page << 'inputChange();'
        end
      end
    else
      @estado_select = Estado.find(:all, :order=>'nombre')
      if @solicitud_avaluo.estado.nil?
        estado_id = @estado_select.first.id
      else
        estado_id = @solicitud_avaluo.estado.id
      end
      municipio_fill(estado_id)
      unless params[:solicitud_id].nil?
        @solicitud = Solicitud.find(params[:solicitud_id])
      end
      render :update do |page|
        page.replace_html 'direccion-select', :partial=>'direccion_select'
      end
    end
  end

  def etiqueta_folio
    if params[:id].to_i == 1
      render :update do |page|
        page.replace_html 'etiqueta_folio', :partial => 'text_folio'
      end
    elsif params[:id].to_i == 2
      render :update do |page|
        page.replace_html 'etiqueta_folio', :partial => 'label_folio'
      end
    elsif params[:id].to_i == 3
      render :update do |page|
        page.replace_html 'etiqueta_tomo', :partial => 'text_tomo'
      end
    elsif params[:id].to_i == 4
      render :update do |page|
        page.replace_html 'etiqueta_tomo', :partial => 'label_tomo'
      end
    elsif params[:id].to_i == 5
      render :update do |page|
        page.replace_html 'etiqueta_protocolo', :partial => 'text_protocolo'
      end
    elsif params[:id].to_i == 6
      render :update do |page|
        page.replace_html 'etiqueta_protocolo', :partial => 'label_protocolo'
      end
    end
  end

  def estado_list
    estado_id = params[:estado_id]
    municipio_fill(estado_id)
    render :update do |page|
      page.replace_html 'municipio-select', :partial => 'municipio_list'
    end
  end

  def estado_change
    estado_id = params[:estado_id]
    municipio_fill(estado_id)
    render :update do |page|
      page.replace_html 'municipio-select', :partial => 'municipio_select'
      page.replace_html 'parroquia-select', :partial => 'parroquia_select'
    end
  end

  def municipio_change
    parroquia_fill(params[:municipio_id])
    render :update do |page|
      page.replace_html 'parroquia-select', :partial => 'parroquia_select'
    end
  end

  def delete
    solicitud_tipo_garantia = SolicitudTipoGarantia.find(params[:id])
    @solicitud = Solicitud.find(solicitud_tipo_garantia.solicitud_id)
    solicitud_tipo_garantia.destroy
    @solicitud_tipo_garantia = SolicitudTipoGarantia.find(:all, :conditions=>['solicitud_id = ?', @solicitud.id])
    render :update do |page|
      page.hide 'error'
      page.remove "tipo_#{params[:id]}"
      #      page.replace_html 'list', :partial => 'list_garantia'
      page.replace_html 'message', I18n.t('Sistema.Body.Modelos.BoletaArrime.Messages.se_elimino_con_exito')
      #      page.show 'list'
      page.show 'message'
    end
  end

  def view
    @solicitud_tipo_garantia = SolicitudTipoGarantia.find(params[:solicitud_tipo_garantia_id])
#    @estatus = @solicitud_tipo_garantia.estatus
    @solicitud_tipo_garantia_id = @solicitud_tipo_garantia.id
    @solicitud = Solicitud.find(@solicitud_tipo_garantia.solicitud_id)
    @solicitud_avaluo = SolicitudAvaluo.find(:all, :conditions=>["estatus = 'H' and solicitud_tipo_garantia_id = ?", @solicitud_tipo_garantia.id], :order => 'id desc')
  end
  
  def view_detalle
    @solicitud_tipo_garantia = SolicitudTipoGarantia.find(params[:solicitud_tipo_garantia_id])
    @estatus = @solicitud_tipo_garantia.estatus
    @solicitud_tipo_garantia_id = @solicitud_tipo_garantia.id
    @solicitud = Solicitud.find(@solicitud_tipo_garantia.solicitud_id)
    @solicitud_avaluo = SolicitudAvaluo.find(:all, :conditions=>["estatus = 'H' and solicitud_tipo_garantia_id = ?", @solicitud_tipo_garantia.id], :order => 'id desc')
  end
  
  def view_garantia
    @solicitud_avaluo = SolicitudAvaluo.find(:first, :conditions=>"solicitud_tipo_garantia_id = #{params[:solicitud_tipo_garantia_id]} and estatus = 'V'")
    @solicitud_tipo_garantia = SolicitudTipoGarantia.find(@solicitud_avaluo.solicitud_tipo_garantia_id)
    @estatus = @solicitud_tipo_garantia.estatus
    @solicitud_tipo_garantia_id = @solicitud_tipo_garantia.id
    @solicitud = Solicitud.find(@solicitud_tipo_garantia.solicitud_id)
    @solicitud_avaluo_imagen = SolicitudAvaluoImagen.find(:all,:conditions=>['solicitud_tipo_garantia_id = ?', @solicitud_tipo_garantia_id])
    if @solicitud_tipo_garantia.tipo_garantia.tipo == "M"
      @rhtml = "mobiliaria_view"
      @mobiliario_tipos_mobiliario_list = SolicitudAvaluoMobiliarioTipos.find(:all, :conditions=>["ubicacion = 'M' and solicitud_tipo_garantia_id = ?", @solicitud_avaluo.solicitud_tipo_garantia_id])
      @mobiliario_tipos_documento_list = SolicitudAvaluoMobiliarioTipos.find(:all, :conditions=>["ubicacion = 'D' and solicitud_tipo_garantia_id = ?", @solicitud_avaluo.solicitud_tipo_garantia_id])
      @solicitud_avaluo_mobiliario = SolicitudAvaluoMobiliario.find(:first, :conditions=>['solicitud_avaluo_id = ? ', params[:id]])
    elsif @solicitud_tipo_garantia.tipo_garantia.tipo == 'I'
      @rhtml = "inmobiliaria_view"
      @solicitud_avaluo_inmobiliario = SolicitudAvaluoInmobiliario.find(:first, :conditions=>['solicitud_avaluo_id = ? ', @solicitud_avaluo.id])
    elsif @solicitud_tipo_garantia.tipo_garantia.tipo == 'P'
      @rhtml = "prenda_view"
      @semoviente_list = TiposSemovientes.find(:all, :order=>'nombre')
      @prenda_semoviente_list = SolicitudAvaluoPrendaSemoviente.find(:all, :conditions=>['solicitud_tipo_garantia_id = ?', @solicitud_avaluo.solicitud_tipo_garantia_id])
      @solicitud_avaluo_prenda = SolicitudAvaluoPrenda.find(:first, :conditions=>['solicitud_avaluo_id = ? ', @solicitud_avaluo.id])
    elsif @solicitud_tipo_garantia.tipo_garantia.tipo == 'F'
      @rhtml  = "fianza_view"
      @solicitud_avaluo_fianza = SolicitudAvaluoFianza.find(:first, :conditions=>['solicitud_avaluo_id = ? ', @solicitud_avaluo.id])
    end
  end

  def view_detail
    @solicitud_avaluo = SolicitudAvaluo.find(params[:id])
    @solicitud_tipo_garantia = SolicitudTipoGarantia.find(@solicitud_avaluo.solicitud_tipo_garantia_id)
    @solicitud_tipo_garantia_id = @solicitud_tipo_garantia.id
    @solicitud = Solicitud.find(@solicitud_tipo_garantia.solicitud_id)
    @solicitud_avaluo_imagen = SolicitudAvaluoImagen.find(:all,:conditions=>['solicitud_tipo_garantia_id = ?', @solicitud_tipo_garantia_id])
    if @solicitud_tipo_garantia.tipo_garantia.tipo == "M"
      @rhtml = "mobiliaria_view"
      @mobiliario_tipos_mobiliario_list = SolicitudAvaluoMobiliarioTipos.find(:all, :conditions=>["ubicacion = 'M' and solicitud_tipo_garantia_id = ?", @solicitud_avaluo.solicitud_tipo_garantia_id])
      @mobiliario_tipos_documento_list = SolicitudAvaluoMobiliarioTipos.find(:all, :conditions=>["ubicacion = 'D' and solicitud_tipo_garantia_id = ?", @solicitud_avaluo.solicitud_tipo_garantia_id])
      @solicitud_avaluo_mobiliario = SolicitudAvaluoMobiliario.find(:first, :conditions=>['solicitud_avaluo_id = ? ', params[:id]])
    elsif @solicitud_tipo_garantia.tipo_garantia.tipo == 'I'
      @rhtml = "inmobiliaria_view"
      @solicitud_avaluo_inmobiliario = SolicitudAvaluoInmobiliario.find(:first, :conditions=>['solicitud_avaluo_id = ? ', @solicitud_avaluo.id])
    elsif @solicitud_tipo_garantia.tipo_garantia.tipo == 'P'
      @rhtml = "prenda_view"
      @semoviente_list = TiposSemovientes.find(:all, :order=>'nombre')
      @prenda_semoviente_list = SolicitudAvaluoPrendaSemoviente.find(:all, :conditions=>['solicitud_tipo_garantia_id = ?', @solicitud_avaluo.solicitud_tipo_garantia_id])
      @solicitud_avaluo_prenda = SolicitudAvaluoPrenda.find(:first, :conditions=>['solicitud_avaluo_id = ? ', @solicitud_avaluo.id])
    elsif @solicitud_tipo_garantia.tipo_garantia.tipo == 'F'
      @rhtml  = "fianza_view"
      @solicitud_avaluo_fianza = SolicitudAvaluoFianza.find(:first, :conditions=>['solicitud_avaluo_id = ? ', @solicitud_avaluo.id])
    end
  end
  
  def view_detalle_especifico
    @solicitud_avaluo = SolicitudAvaluo.find(params[:id])
    @solicitud_tipo_garantia = SolicitudTipoGarantia.find(@solicitud_avaluo.solicitud_tipo_garantia_id)
    @estatus = @solicitud_tipo_garantia.estatus
    @solicitud_tipo_garantia_id = @solicitud_tipo_garantia.id
    @solicitud = Solicitud.find(@solicitud_tipo_garantia.solicitud_id)
    @solicitud_avaluo_imagen = SolicitudAvaluoImagen.find(:all,:conditions=>['solicitud_tipo_garantia_id = ?', @solicitud_tipo_garantia_id])
    if @solicitud_tipo_garantia.tipo_garantia.tipo == "M"
      @rhtml = "mobiliaria_view"
      @mobiliario_tipos_mobiliario_list = SolicitudAvaluoMobiliarioTipos.find(:all, :conditions=>["ubicacion = 'M' and solicitud_tipo_garantia_id = ?", @solicitud_avaluo.solicitud_tipo_garantia_id])
      @mobiliario_tipos_documento_list = SolicitudAvaluoMobiliarioTipos.find(:all, :conditions=>["ubicacion = 'D' and solicitud_tipo_garantia_id = ?", @solicitud_avaluo.solicitud_tipo_garantia_id])
      @solicitud_avaluo_mobiliario = SolicitudAvaluoMobiliario.find(:first, :conditions=>['solicitud_avaluo_id = ? ', params[:id]])
    elsif @solicitud_tipo_garantia.tipo_garantia.tipo == 'I'
      @rhtml = "inmobiliaria_view"
      @solicitud_avaluo_inmobiliario = SolicitudAvaluoInmobiliario.find(:first, :conditions=>['solicitud_avaluo_id = ? ', @solicitud_avaluo.id])
    elsif @solicitud_tipo_garantia.tipo_garantia.tipo == 'P'
      @rhtml = "prenda_view"
      @semoviente_list = TiposSemovientes.find(:all, :order=>'nombre')
      @prenda_semoviente_list = SolicitudAvaluoPrendaSemoviente.find(:all, :conditions=>['solicitud_tipo_garantia_id = ?', @solicitud_avaluo.solicitud_tipo_garantia_id])
      @solicitud_avaluo_prenda = SolicitudAvaluoPrenda.find(:first, :conditions=>['solicitud_avaluo_id = ? ', @solicitud_avaluo.id])
    elsif @solicitud_tipo_garantia.tipo_garantia.tipo == 'F'
      @rhtml  = "fianza_view"
      @solicitud_avaluo_fianza = SolicitudAvaluoFianza.find(:first, :conditions=>['solicitud_avaluo_id = ? ', @solicitud_avaluo.id])
    end
  end
  
  def view_constitucion
    @solicitud_tipo_garantia = SolicitudTipoGarantia.find(params[:solicitud_tipo_garantia_id])
    @estatus = @solicitud_tipo_garantia.estatus
    @solicitud_tipo_garantia_id = @solicitud_tipo_garantia.id
    @solicitud = Solicitud.find(params[:solicitud_id])
    @indice = SolicitudTipoGarantia.indice_garantia(@solicitud_tipo_garantia.relacion_garantia, @solicitud.monto_solicitado)
    referencia = SolicitudTipoGarantia.get_valor(@solicitud.id)
    @valor_referencia = referencia[0]
    @total_referencia = referencia[1]
    @solicitud_constitucion_garantia = SolicitudConstitucionGarantia.find(:first, :conditions=>['solicitud_tipo_garantia_id = ?', @solicitud_tipo_garantia.id])
#    estado_id = @solicitud_constitucion_garantia.estado.id
#    municipio_fill(estado_id)
  end

  def cancel_new
    @solicitud = Solicitud.find(params[:id])
    render :update do |page|
      page.hide 'message'
      page.hide 'error'
      page.replace_html 'boton_new', :partial => 'boton_agregar'
      page.show 'boton_new'
    end
  end

  def save_archivo
    @sol_id = params[:solicitud_id]
    @solicitud_tg_id = params[:solicitud_tipo_garantia_id]
    @imagen = SolicitudAvaluoImagen.first
    if @imagen.validates_upload_file(params[:upload]) == false
      count = SolicitudAvaluoImagen.count(:conditions=>"nombre_imagen = 'sol#{@solicitud_tg_id}' and nombre_real = '#{params[:upload][:datafile].original_filename.to_s}' and referencia = '#{params[:upload][:referencia].to_s}'")
      if count == 0
        resultado = @imagen.save_archivo(params[:upload],Rails.root.join('public','documentos', 'images_avaluo'),params[:solicitud_tipo_garantia_id])
        if resultado == true
          flash[:notice] = I18n.t('Sistema.Body.Vistas.GestionarGarantia.Mensajes.se_cargo_archivo')
        else
          flash[:notice] = I18n.t('Sistema.Body.Vistas.GestionarGarantia.Mensajes.no_cargo_archivo')
          @display = "false"
        end
      else
        @imagen.errors.add(:solicitud_avaluo_imagen, I18n.t('Sistema.Body.Vistas.GestionarGarantia.Mensajes.ya_existe_archivo'))
        flash[:notice] = nil
        flash[:error] = @imagen
        @display = "false"
      end
    else
      flash[:notice] = nil
      flash[:error] = @imagen
    end
  end

  protected
  def common
    super
    @form_title = I18n.t('Sistema.Body.Vistas.GestionarGarantia.Header.form_title')
    @form_title_record = I18n.t('Sistema.Body.Vistas.GestionarGarantia.Header.title')
    @form_title_records = I18n.t('Sistema.Body.Vistas.GestionarGarantia.Header.title')
    @form_entity = I18n.t('Sistema.Body.Vistas.GestionarGarantia.Etiquetas.aspecto')
    #@form_identity_field = 'numero'
    @width_layout = '960'
  end


  private
  def municipio_fill(estado_id)
    @municipio_select = Municipio.find(:all, :conditions=>["estado_id = #{estado_id}", :order=>'nombre'])
    if @solicitud_avaluo.nil? || @solicitud_avaluo.municipio.nil?
      municipio_id = @municipio_select.first.id
    else
      municipio_id = @solicitud_avaluo.municipio.id
    end
    parroquia_fill(municipio_id)
  end

  def parroquia_fill(municipio_id)
    @parroquia_select = Parroquia.find(:all, :conditions=>["municipio_id = #{municipio_id}", :order=>'nombre'])
  end



  def borrar_imagen(id)
    solicitud_avaluo_imagen = SolicitudAvaluoImagen.find(id)
    solicitud_tipo_garantia_id = solicitud_avaluo_imagen.solicitud_tipo_garantia_id
    path_to_file = Rails.root.join('public','documentos', 'images_avaluo',"sol#{solicitud_avaluo_imagen.solicitud_tipo_garantia_id}.#{solicitud_avaluo_imagen.nombre_real.to_s}")
    File.delete(path_to_file) if File.exist?(path_to_file)
    solicitud_avaluo_imagen.destroy
    return solicitud_tipo_garantia_id
  end

end

