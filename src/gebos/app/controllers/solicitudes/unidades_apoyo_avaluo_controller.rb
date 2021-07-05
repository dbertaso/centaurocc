# encoding: utf-8

#require 'rubygems'
#require 'jcode'
#require 'ftools'
#$KCODE = 'u'

#SOLO SE MIGRO EL METODO DELETE_MOBILIARIA

require 'rubygems'
require 'roo'
String#encode = 'u'

class Solicitudes::UnidadesApoyoAvaluoController < FormTabsController

 layout 'form_basic'

  def index
    @form_title = 'Revisión Inspección y Avalúos'
    @estado = Estado.find(:all, :order => 'nombre')
    @sector_economico = SectorEconomico.find(:all, :conditions=>['activo = true and id <> 1000'], :order=>'descripcion')
  end

  def list
    @condition ="const_id = 'ST0004' and avaluo = false"
    params['sort'] = "numero" unless params['sort']
    unless params[:sector_economico_id].to_s.nil? || params[:sector_economico_id].to_s.empty?
      sector_economico_id = params[:sector_economico_id].to_s
      sector = SectorEconomico.find(sector_economico_id)
      @condition << " and (cliente_numero in (select id from empresa where sector_economico_id = #{@params[:sector_economico_id]}) or cliente_numero in (select id from persona where sector_economico_id = #{@params[:sector_economico_id]}))"
      @form_search_expression << "Sector Económico es igual '#{sector.descripcion}'"
    end

    unless params[:estado_id].to_s.nil? || params[:estado_id].to_s.empty?
      estado_id =params[:estado_id].to_s
      estado = Estado.find(estado_id)
      @condition << " and estado_id = " + estado_id
      @form_search_expression << "Estado es igual '#{estado.nombre}'"
    end

    unless params[:numero].nil? || params[:numero].empty?
      @condition << " AND numero =  #{params[:numero].to_i}"
      @form_search_expression << "Número igual '#{params[:numero]}'"
    end

    unless params[:identificacion].nil? ||  params[:identificacion].empty?
      @condition << " AND UPPER(cedula_rif) LIKE UPPER('%#{params[:identificacion].strip}%') "
      @form_search_expression << "Rif o Cédula contenga '#{params[:identificacion]}'"
    end

    unless params[:nombre].nil? || params[:nombre].empty?
      @condition << " AND UPPER(nombre) LIKE UPPER('%#{params[:nombre].strip}%')"
      @form_search_expression << "Apellido / Empresa contenga '#{params[:nombre]}'"
    end

    @total = ViewSolicitudPreEvaluacion.count(:conditions=>@condition)
    @pages, @list = paginate(:solicitud, :class_name => 'ViewSolicitudPreEvaluacion',
     :per_page => @records_by_page,
     :conditions => @condition,
     :select=>'*',
     :order_by => params['sort'])

    form_list
  end

  def editar_mobiliaria
  end

  def edit
    @form_title = 'Revisión Inspección y Avalúos'
    @solicitud = Solicitud.find(params[:id])
    SolicitudRecaudoAvaluo.crear(@solicitud)
    @solicitud_obra_civil = SolicitudObraCivil.find(:first, :conditions=>['solicitud_id = ?', @solicitud.id])
    if @solicitud_obra_civil.nil?
      @solicitud_obra_civil = SolicitudObraCivil.new
    end
    if @solicitud.avaluo_obra_civil
      @solicitud_recaudo_avaluo = SolicitudRecaudoAvaluo.find_by_sql("SELECT s.*, r.descripcion FROM solicitud_recaudo_avaluo s join recaudos_avaluos_inspecciones r on r.id = s.recaudos_avaluos_inspecciones_id WHERE r.obras_civiles = true and s.solicitud_id = #{@solicitud.id} order by r.descripcion")
    else
      @solicitud_recaudo_avaluo = SolicitudRecaudoAvaluo.find_by_sql("SELECT s.*, r.descripcion FROM solicitud_recaudo_avaluo s join recaudos_avaluos_inspecciones r on r.id = s.recaudos_avaluos_inspecciones_id WHERE r.obras_civiles = false and s.solicitud_id = #{@solicitud.id} order by r.descripcion")
    end
  end

  def generar
    @solicitud = Solicitud.find(params[:id])
    @solicitud.avaluo_obra_civil = params[:avaluo_obra_civil]
    @solicitud.save
    @solicitud_obra_civil = SolicitudObraCivil.find(:first, :conditions=>['solicitud_id = ?', @solicitud.id])
    if @solicitud_obra_civil.nil?
      @solicitud_obra_civil = SolicitudObraCivil.new
    end
    if @solicitud.avaluo_obra_civil
      @solicitud_recaudo_avaluo = SolicitudRecaudoAvaluo.find_by_sql("SELECT s.*, r.descripcion FROM solicitud_recaudo_avaluo s join recaudos_avaluos_inspecciones r on r.id = s.recaudos_avaluos_inspecciones_id WHERE r.obras_civiles = true and s.solicitud_id = #{@solicitud.id} order by r.descripcion")
    else
      @solicitud_recaudo_avaluo = SolicitudRecaudoAvaluo.find_by_sql("SELECT s.*, r.descripcion FROM solicitud_recaudo_avaluo s join recaudos_avaluos_inspecciones r on r.id = s.recaudos_avaluos_inspecciones_id WHERE r.obras_civiles = false and s.solicitud_id = #{@solicitud.id} order by r.descripcion")
    end
    if params[:avaluo_obra_civil] == 'true'
      render :update do |page|
    		page.hide 'error'
        page.replace_html 'formulario', :partial => 'form'
        page.replace_html 'list', :partial => 'lista'
        page.show 'formulario'
        page.show 'list'
  		end
    else
      render :update do |page|
    		page.hide 'error'
        page.replace_html 'list', :partial => 'lista'
        page.hide 'formulario'
        page.show 'list'
  		end
    end
  end

  def save_revisado
    solicitud_recaudo_avaluo = SolicitudRecaudoAvaluo.find(params[:id])
    solicitud_recaudo_avaluo.update_attributes(:revisado=>params[:revisado])
    render :update do |page|
      message = "El recaudo '#{solicitud_recaudo_avaluo.RecaudosAvaluosInspecciones.descripcion}' se modificó con éxito."
      page.hide 'error'
      page.visual_effect :highlight, "row_#{solicitud_recaudo_avaluo.id}", :duration => 0.6
      page.replace_html 'message', message
      page.show 'message'
    end
  end

  def save_observaciones
    solicitud_recaudo_avaluo = SolicitudRecaudoAvaluo.find(params[:id])
    solicitud_recaudo_avaluo.update_attributes(:observaciones=>params[:observaciones])
    render :update do |page|
      message = "El recaudo '#{solicitud_recaudo_avaluo.RecaudosAvaluosInspecciones.descripcion}' se modificó con éxito."
      page.hide 'error'
      page.visual_effect :highlight, "row_#{solicitud_recaudo_avaluo.id}", :duration => 0.6
      page.replace_html 'message', message
      page.show 'message'
    end
  end

  def save_edit
    @solicitud = Solicitud.find(params[:solicitud_id])
    errores = SolicitudObraCivil.crear_obra_civil(@solicitud.id, params[:solicitud_obra_civil])
    if errores == true
      flash[:notice] = "Datos de la obra civil se guardaron con éxito"
      render :update do |page|
        new_options = {:action=>'edit', :id=>@solicitud.id }
        page.redirect_to new_options
      end
    else
      render :update do |page|
         page.hide 'message'
         page.hide 'error'
         page.replace_html 'errorExplanation','<h2>Ha ocurrido un error</h2><p><UL>' << errores << '</UL></p>'
         page.show 'errorExplanation'
         page.<< "window.scrollTo(0,0);"
      end
    end
  end

  def informe
    @form_title = 'Revisión Inspección y Avalúos'
    @solicitud = Solicitud.find(params[:solicitud_id])
    @solicitud_tipo_garantia = SolicitudTipoGarantia.find(:all, :conditions=>['solicitud_id = ?', @solicitud.id])
  end

  def edit_informe
    @form_title = 'Revisión Inspección y Avalúos'
    total = SolicitudAvaluo.count(:conditions=>['solicitud_id = ? and solicitud_tipo_garantia_id = ?',params[:solicitud_id], params[:id]])
    solicitud_tipo_garantia = SolicitudTipoGarantia.find(params[:id])
    @solicitud_tipo_garantia_id = solicitud_tipo_garantia.id
    @solicitud_tipo_garantia_1 = solicitud_tipo_garantia
    @solicitud = Solicitud.find(solicitud_tipo_garantia.solicitud_id)
    @solicitud_avaluo_imagen = SolicitudAvaluoImagen.find(:all,:conditions=>['solicitud_tipo_garantia_id = ?', @solicitud_tipo_garantia_id])
    if total > 0
      @solicitud_avaluo = SolicitudAvaluo.find(:first, :conditions=>['solicitud_tipo_garantia_id = ?',params[:id]])
      @editar = 1
    else
      @solicitud_avaluo = SolicitudAvaluo.new
      @editar = 0
    end
    if solicitud_tipo_garantia.TipoGarantia.tipo == "M"
      @rhtml = "mobiliaria"
      @solicitud_avaluo_mobiliario = SolicitudAvaluoMobiliario.new
      @mobiliario_tipos_mobiliario_list = SolicitudAvaluoMobiliarioTipos.find(:all, :conditions=>["ubicacion = 'M' and solicitud_tipo_garantia_id = ?", params[:id]])
      @mobiliario_tipos_documento_list = SolicitudAvaluoMobiliarioTipos.find(:all, :conditions=>["ubicacion = 'D' and solicitud_tipo_garantia_id = ?", params[:id]])
      if total > 0 && SolicitudAvaluoMobiliario.count(:conditions=>['solicitud_avaluo_id = ? ', @solicitud_avaluo.id]) > 0
        @solicitud_avaluo_mobiliario = SolicitudAvaluoMobiliario.find(:first, :conditions=>['solicitud_avaluo_id = ? ', @solicitud_avaluo.id])
      end
    elsif solicitud_tipo_garantia.TipoGarantia.tipo == 'I'
      @rhtml = "inmobiliaria"
      if total > 0 && SolicitudAvaluoInmobiliario.count(:conditions=>['solicitud_avaluo_id = ? ', @solicitud_avaluo.id]) > 0
        @solicitud_avaluo_inmobiliario = SolicitudAvaluoInmobiliario.find(:first, :conditions=>['solicitud_avaluo_id = ? ', @solicitud_avaluo.id])
      else
        @solicitud_avaluo_inmobiliario = SolicitudAvaluoInmobiliario.new
        @solicitud_avaluo_inmobiliario.clasificacion = 'T'
      end
    elsif solicitud_tipo_garantia.TipoGarantia.tipo == 'P'
      @rhtml = "prenda"
      @semoviente_list = TiposSemovientes.find(:all, :order=>'nombre')
      @prenda_semoviente_list = SolicitudAvaluoPrendaSemoviente.find(:all, :conditions=>['solicitud_tipo_garantia_id = ?', params[:id]])
      if total > 0 && SolicitudAvaluoPrenda.count(:conditions=>['solicitud_avaluo_id = ? ', @solicitud_avaluo.id]) > 0
        @solicitud_avaluo_prenda = SolicitudAvaluoPrenda.find(:first, :conditions=>['solicitud_avaluo_id = ? ', @solicitud_avaluo.id])
      else
        @solicitud_avaluo_prenda = SolicitudAvaluoPrenda.new
      end
    elsif solicitud_tipo_garantia.TipoGarantia.tipo == 'F'
      @rhtml  = "fianza"
      @solicitud_avaluo_fianza = SolicitudAvaluoFianza.new
      if total > 0 && SolicitudAvaluoFianza.count(:conditions=>['solicitud_avaluo_id = ? ', @solicitud_avaluo.id]) > 0
        @solicitud_avaluo_fianza = SolicitudAvaluoFianza.find(:first, :conditions=>['solicitud_avaluo_id = ? ', @solicitud_avaluo.id])
      end
      @nacionalidad_select = Nacionalidad.find_by_sql("select id, masculino as descripcion from nacionalidad" )
    end
    @estado_select = Estado.find(:all, :order=>'nombre')
    if @solicitud_avaluo.Estado.nil?
      estado_id = @estado_select.first.id
    else
      estado_id = @solicitud_avaluo.Estado.id
    end
    municipio_fill(estado_id)
  end

  def new
    @form_title = 'Revisión Inspección y Avalúos'
    @solicitud = Solicitud.find(params[:id])
    @tipo_garantia_list = TipoGarantia.find(:all, :conditions=>['activo = true and id in (select tipo_garantia_id from programa_tipo_garantia where programa_id = ?)',@solicitud.programa.id])
    render :update do |page|
       page.hide 'message'
       page.hide 'error'
       page.replace_html 'boton_new', :partial => 'new'
       page.show 'boton_new'
    end
  end

  def save_new_informe
    @solicitud = Solicitud.find(params[:solicitud_id])
    resultado = SolicitudTipoGarantia.crear_registro(params[:solicitud_tipo_garantia], @solicitud.id)
    if resultado == true
      @solicitud_tipo_garantia = SolicitudTipoGarantia.find(:all, :conditions=>['solicitud_id = ?', @solicitud.id])
      render :update do |page|
         page.hide 'error'
         page.replace_html 'list', :partial => 'list_garantia'
         page.replace_html 'boton_new', :partial => 'boton_agregar'
         page.replace_html 'message', "Tipo de garantía se guardó con éxito"
         page.show 'boton_new'
         page.show 'list'
         page.show 'message'
      end
    else
      render :update do |page|
         page.hide 'message'
         page.hide 'error'
         page.replace_html 'errorExplanation','<h2>Ha ocurrido un error</h2><p><UL>' << resultado << '</UL></p>'
         page.show 'errorExplanation'
         page.<< "window.scrollTo(0,0);"
      end
    end
  end

  def save_informe_new
    solicitud_tipo_garantia = SolicitudTipoGarantia.find(params[:solicitud_tipo_garantia_id])
    if solicitud_tipo_garantia.TipoGarantia.tipo == 'M'
      parametros = params[:solicitud_avaluo_mobiliario]
    elsif solicitud_tipo_garantia.TipoGarantia.tipo == 'I'
      parametros = params[:solicitud_avaluo_inmobiliario]
    elsif solicitud_tipo_garantia.TipoGarantia.tipo == 'F'
      parametros = params[:solicitud_avaluo_fianza]
    elsif solicitud_tipo_garantia.TipoGarantia.tipo == 'P'
      parametros = params[:solicitud_avaluo_prenda]
    end
    errores = SolicitudAvaluo.crear_registro(params[:solicitud_avaluo], parametros, params[:solicitud_id], params[:solicitud_tipo_garantia_id])
    if errores == true
      flash[:notice] = "Datos del informe se guardaron con éxito"
      render :update do |page|
        new_options = {:action=>'edit_informe', :id=>params[:solicitud_tipo_garantia_id], :solicitud_id=>params[:solicitud_id] }
        page.redirect_to new_options
      end
    else
      render :update do |page|
         page.hide 'message'
         page.replace_html 'errorExplanation','<h2>Ha ocurrido un error</h2><p><UL>' << errores << '</UL></p>'
         page.show 'errorExplanation'
         page.<< "window.scrollTo(0,0);"
      end
    end
  end

  def save_informe_edit
    solicitud_avaluo = SolicitudAvaluo.find(params[:id])
    if solicitud_avaluo.SolicitudTipoGarantia.TipoGarantia.tipo == 'M'
      parametros = params[:solicitud_avaluo_mobiliario]
    elsif solicitud_avaluo.SolicitudTipoGarantia.TipoGarantia.tipo == 'I'
      parametros = params[:solicitud_avaluo_inmobiliario]
    elsif solicitud_avaluo.SolicitudTipoGarantia.TipoGarantia.tipo == 'F'
      parametros = params[:solicitud_avaluo_fianza]
    elsif solicitud_avaluo.SolicitudTipoGarantia.TipoGarantia.tipo == 'P'
      parametros = params[:solicitud_avaluo_prenda]
    end
    errores = SolicitudAvaluo.editar_registro(params[:solicitud_avaluo], parametros, params[:id])
    if errores == true
      solicitud_avaluo = SolicitudAvaluo.find(params[:id])
      flash[:notice] = "Datos del informe se guardaron con éxito"
      render :update do |page|
        new_options = {:action=>'edit_informe', :id=>solicitud_avaluo.solicitud_tipo_garantia_id, :solicitud_id=>solicitud_avaluo.solicitud_id }
        page.redirect_to new_options
      end
    else
      render :update do |page|
         page.hide 'message'
         page.replace_html 'errorExplanation','<h2>Ha ocurrido un error</h2><p><UL>' << errores << '</UL></p>'
         page.show 'errorExplanation'
         page.<< "window.scrollTo(0,0);"
      end
    end
  end

  def save_new_semoviente
    errores = SolicitudAvaluoPrendaSemoviente.create_new(params[:solicitud_avaluo_prenda_semoviente], params[:solicitud_tipo_garantia_id])
    if errores == true
      @prenda_semoviente_list = SolicitudAvaluoPrendaSemoviente.find(:all, :conditions=>['solicitud_tipo_garantia_id = ?', params[:solicitud_tipo_garantia_id]])
      @semoviente_list = TiposSemovientes.find(:all, :order=>'nombre')
      render :update do |page|
        page.hide 'errorExplanation'
        page.replace_html 'semovientes', :partial => 'prenda_semoviente'
        page.replace_html 'message', "Datos del semoviente se guardaron con éxito"
        page.show 'semovientes'
        page.show 'message'
        page.<< "window.scrollTo(0,200);"
      end
    else
      render :update do |page|
         page.hide 'message'
         page.replace_html 'errorExplanation','<h2>Ha ocurrido un error</h2><p><UL>' << errores << '</UL></p>'
         page.show 'errorExplanation'
         page.<< "window.scrollTo(0,0);document.getElementById('agregar').style.display= '';"
      end
    end
  end

  def delete_semoviente
    SolicitudAvaluoPrendaSemoviente.delete_registro(params[:id])
    @prenda_semoviente_list = SolicitudAvaluoPrendaSemoviente.find(:all, :conditions=>['solicitud_tipo_garantia_id = ?', params[:solicitud_tipo_garantia_id]])
    @semoviente_list = TiposSemovientes.find(:all, :order=>'nombre')
    render :update do |page|
      page.hide 'errorExplanation'
      page.replace_html 'semovientes', :partial => 'prenda_semoviente'
      page.replace_html 'message', "Se ha eliminado el registro con éxito"
      page.show 'semovientes'
      page.show 'message'
      page.<< "window.scrollTo(0,200);"
    end
  end


  def save_new_mobiliaria1
    errores = SolicitudAvaluoMobiliarioTipos.create_new(params[:solicitud_avaluo_mobiliario_tipos], params[:solicitud_tipo_garantia_id])
    if errores == true
      @mobiliario_tipos_mobiliario_list = SolicitudAvaluoMobiliarioTipos.find(:all, :conditions=>["ubicacion = 'M' and solicitud_tipo_garantia_id = ?", params[:solicitud_tipo_garantia_id]])
      render :update do |page|
        page.hide 'errorExplanation'
        page.replace_html 'mobiliaria', :partial => 'mobiliaria_tipo_mobiliario'
        page.replace_html 'message', "Datos mobiliaria se guardaron con éxito"
        page.show 'mobiliaria'
        page.show 'message'
        page.<< "window.scrollTo(0,200);"
      end
    else
      render :update do |page|
         page.hide 'message'
         page.replace_html 'errorExplanation','<h2>Ha ocurrido un error</h2><p><UL>' << errores << '</UL></p>'
         page.show 'errorExplanation'
         page.<< "window.scrollTo(0,200);document.getElementById('agregar').style.display= '';"
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
        page.replace_html 'message', "Datos mobiliaria se guardaron con éxito"
        page.show 'documento'
        page.show 'message'
        page.<< "window.scrollTo(0,200);"
      end
    else
      render :update do |page|
         page.hide 'message'
         page.replace_html 'errorExplanation','<h2>Ha ocurrido un error</h2><p><UL>' << errores << '</UL></p>'
         page.show 'errorExplanation'
         page.<< "window.scrollTo(0,200);document.getElementById('agregar').style.display= '';"
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
      page.replace_html 'message', "Se ha actualizado el registro con éxito"
      page.show 'mobiliaria'
      page.show 'message'
    end
 end


  def delete_mobiliaria
      @rhtml = "mobiliaria"
      @solicitud_avaluo_mobiliario = SolicitudAvaluoMobiliario.new
      @mobiliario_tipos_mobiliario_list = SolicitudAvaluoMobiliarioTipos.find(:all, :conditions=>["ubicacion = 'M' and solicitud_tipo_garantia_id = ?", params[:id]])
      @mobiliario_tipos_documento_list = SolicitudAvaluoMobiliarioTipos.find(:all, :conditions=>["ubicacion = 'D' and solicitud_tipo_garantia_id = ?", params[:id]])
    SolicitudAvaluoMobiliarioTipos.delete_registro(params[:id])
    render :update do |page|
      page.hide 'errorExplanation'
      page.replace_html 'mobiliaria', :partial => 'mobiliaria_tipo_mobiliario'
      page.replace_html 'documento', :partial => 'mobiliaria_tipo_documento'
      page.replace_html 'message', "Se ha eliminado el registro con éxito"
      page.show 'mobiliaria'
      page.show 'documento'
      page.show 'message'
      page.<< "window.scrollTo(0,200);"
    end
  end

  def save_archivo_new
    @form_title = 'Revisión Inspección y Avalúos'
    resultado = save(params[:upload],params[:solicitud_id],params[:solicitud_tipo_garantia_id], params[:solicitud_avaluo_imagen_1])
    unless resultado == true
      flash[:notice] = "El archivo no se pudo cargar"
      @display = "false"
    else
      flash[:notice] = "El archivo se cargo con éxito"
    end
    @solicitud_id = params[:solicitud_id]
    @solicitud_tipo_garantia_id = params[:solicitud_tipo_garantia_id]
  end

  def delete_imagen
    @solicitud_tipo_garantia_id = borrar_imagen(params[:id])
    solicitud_tipo_garantia = SolicitudTipoGarantia.find(@solicitud_tipo_garantia_id)
    @solicitud = Solicitud.find(solicitud_tipo_garantia.solicitud_id)
    @solicitud_avaluo_imagen = SolicitudAvaluoImagen.find(:all,:conditions=>['solicitud_tipo_garantia_id = ?', @solicitud_tipo_garantia_id])
    render :update do |page|
      page.hide 'errorExplanation'
      page.replace_html 'archivo', :partial => 'archivo'
      page.replace_html 'message', "Se ha eliminado el registro con éxito"
      page.show 'archivo'
      page.show 'message'
      page.<< "window.scrollTo(0,200);"
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
          @direccion = EmpresaDireccion.find(:first, :conditions=>["empresa_id = ? and tipo = 'P'", @cliente.empresa.id])
        else
          @direccion = EmpresaDireccion.find(:first, :conditions=>["empresa_id = ? and unidad_negocio = true", @cliente.empresa.id])
        end
      else
        if params[:id].to_i == 1
          @direccion = PersonaDireccion.find(:first, :conditions=>["persona_id = ? and tipo = 'H'", @cliente.persona.id])
        else
          @direccion = PersonaDireccion.find(:first, :conditions=>["persona_id = ? and unidad_negocio = true", @cliente.persona.id])
        end
      end

      if @direccion.nil?
        if params[:id].to_i == 1
          mensaje = "El cliente no posee ubicación de la 'Sede Principal'"
        else
          mensaje = "El cliente no posee ubicación marcada como 'Unidad de Negocio'"
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
      if @solicitud_avaluo.Estado.nil?
        estado_id = @estado_select.first.id
      else
        estado_id = @solicitud_avaluo.Estado.id
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
      page.replace_html 'list', :partial => 'list_garantia'
      page.replace_html 'message', "Se ha eliminado el registro con éxito"
      page.show 'list'
      page.show 'message'
    end
  end

  def cancel
    @solicitud = Solicitud.find(params[:id])
    render :update do |page|
       page.hide 'message'
       page.hide 'error'
       page.replace_html 'boton_new', :partial => 'boton_agregar'
       page.show 'boton_new'
    end
  end

  def avanzar
    solicitud = Solicitud.find(params[:id])
    solicitud.avanzar_unidad_apoyo_consultoria(@usuario.id, 2)
    if solicitud.errors.length > 0
      message = '<h2>Ha ocurrido un error</h2><p><UL>'
      solicitud.errors.each { |e|
        message << "#{e[1]}"
      }
      message << '</UL></p>'
      render :update do |page|
        page.replace_html 'errorExplanation',message
        page.show 'errorExplanation'
      end
    else
      render :update do |page|
        page.remove "row_#{solicitud.id}"
        page.hide 'errorExplanation'
        page.replace_html 'message', "La Solicitud Número #{solicitud.numero} se ha pre-evaluado con éxito."
        page.show 'message'
      end
    end
  end

  def view
    @form_title = 'Revisión Inspección y Avalúos'
    @solicitud = Solicitud.find(params[:solicitud_id])
    @solicitud_obra_civil = SolicitudObraCivil.find(:first, :conditions=>['solicitud_id = ?', @solicitud.id])
    if @solicitud.avaluo_obra_civil
      @solicitud_recaudo_avaluo = SolicitudRecaudoAvaluo.find_by_sql("SELECT s.*, r.descripcion FROM solicitud_recaudo_avaluo s join recaudos_avaluos_inspecciones r on r.id = s.recaudos_avaluos_inspecciones_id WHERE r.obras_civiles = true and s.solicitud_id = #{@solicitud.id} order by r.descripcion")
    else
      @solicitud_recaudo_avaluo = SolicitudRecaudoAvaluo.find_by_sql("SELECT s.*, r.descripcion FROM solicitud_recaudo_avaluo s join recaudos_avaluos_inspecciones r on r.id = s.recaudos_avaluos_inspecciones_id WHERE r.obras_civiles = false and s.solicitud_id = #{@solicitud.id} order by r.descripcion")
    end
  end

  def informe_view
    @form_title = 'Revisión Inspección y Avalúos'
    @solicitud = Solicitud.find(params[:solicitud_id])
    @solicitud_tipo_garantia = SolicitudTipoGarantia.find(:all, :conditions=>['solicitud_id = ?', @solicitud.id])
  end

  def edit_view
    @form_title = 'Revisión Inspección y Avalúos'
    solicitud_tipo_garantia = SolicitudTipoGarantia.find(params[:id])
    @solicitud_tipo_garantia_id = solicitud_tipo_garantia.id
    @solicitud = Solicitud.find(solicitud_tipo_garantia.solicitud_id)
    @solicitud_avaluo_imagen = SolicitudAvaluoImagen.find(:all,:conditions=>['solicitud_tipo_garantia_id = ?', @solicitud_tipo_garantia_id])
    @solicitud_avaluo = SolicitudAvaluo.find(:first, :conditions=>['solicitud_tipo_garantia_id = ?',params[:id]])
    if solicitud_tipo_garantia.TipoGarantia.tipo == "M"
      @rhtml = "mobiliaria_view"
      @mobiliario_tipos_mobiliario_list = SolicitudAvaluoMobiliarioTipos.find(:all, :conditions=>["ubicacion = 'M' and solicitud_tipo_garantia_id = ?", params[:id]])
      @mobiliario_tipos_documento_list = SolicitudAvaluoMobiliarioTipos.find(:all, :conditions=>["ubicacion = 'D' and solicitud_tipo_garantia_id = ?", params[:id]])
      @solicitud_avaluo_mobiliario = SolicitudAvaluoMobiliario.find(:first, :conditions=>['solicitud_avaluo_id = ? ', @solicitud_avaluo.id])
    elsif solicitud_tipo_garantia.TipoGarantia.tipo == 'I'
      @rhtml = "inmobiliaria_view"
      @solicitud_avaluo_inmobiliario = SolicitudAvaluoInmobiliario.find(:first, :conditions=>['solicitud_avaluo_id = ? ', @solicitud_avaluo.id])
    elsif solicitud_tipo_garantia.TipoGarantia.tipo == 'P'
      @rhtml = "prenda_view"
      @semoviente_list = TiposSemovientes.find(:all, :order=>'nombre')
      @prenda_semoviente_list = SolicitudAvaluoPrendaSemoviente.find(:all, :conditions=>['solicitud_tipo_garantia_id = ?', params[:id]])
      @solicitud_avaluo_prenda = SolicitudAvaluoPrenda.find(:first, :conditions=>['solicitud_avaluo_id = ? ', @solicitud_avaluo.id])
    elsif solicitud_tipo_garantia.TipoGarantia.tipo == 'F'
      @rhtml  = "fianza_view"
      @solicitud_avaluo_fianza = SolicitudAvaluoFianza.find(:first, :conditions=>['solicitud_avaluo_id = ? ', @solicitud_avaluo.id])
    end
  end

  def imprimir
    @width_layout = '955'
    solicitud_tipo_garantia = SolicitudTipoGarantia.find(params[:id])
    @solicitud_tipo_garantia_id = solicitud_tipo_garantia.id
    @solicitud = Solicitud.find(solicitud_tipo_garantia.solicitud_id)
    @solicitud_avaluo_imagen = SolicitudAvaluoImagen.find(:all,:conditions=>['solicitud_tipo_garantia_id = ?', @solicitud_tipo_garantia_id])
    @solicitud_avaluo = SolicitudAvaluo.find(:first, :conditions=>['solicitud_tipo_garantia_id = ?',params[:id]])
    if solicitud_tipo_garantia.TipoGarantia.tipo == "M"
      @rhtml = "mobiliaria"
      @tipo = "Mobiliaria"
      @mobiliario_tipos_mobiliario_list = SolicitudAvaluoMobiliarioTipos.find(:all, :conditions=>["ubicacion = 'M' and solicitud_tipo_garantia_id = ?", params[:id]])
      @mobiliario_tipos_documento_list = SolicitudAvaluoMobiliarioTipos.find(:all, :conditions=>["ubicacion = 'D' and solicitud_tipo_garantia_id = ?", params[:id]])
      @solicitud_avaluo_mobiliario = SolicitudAvaluoMobiliario.find(:first, :conditions=>['solicitud_avaluo_id = ? ', @solicitud_avaluo.id])
    elsif solicitud_tipo_garantia.TipoGarantia.tipo == 'I'
      @rhtml = "inmobiliaria"
      @tipo = "Inmobiliaria"
      @solicitud_avaluo_inmobiliario = SolicitudAvaluoInmobiliario.find(:first, :conditions=>['solicitud_avaluo_id = ? ', @solicitud_avaluo.id])
    elsif solicitud_tipo_garantia.TipoGarantia.tipo == 'P'
      @rhtml = "prenda"
      @tipo = "Prenda sin desplazamiento de posesión"
      @semoviente_list = TiposSemovientes.find(:all, :order=>'nombre')
      @prenda_semoviente_list = SolicitudAvaluoPrendaSemoviente.find(:all, :conditions=>['solicitud_tipo_garantia_id = ?', params[:id]])
      @solicitud_avaluo_prenda = SolicitudAvaluoPrenda.find(:first, :conditions=>['solicitud_avaluo_id = ? ', @solicitud_avaluo.id])
    elsif solicitud_tipo_garantia.TipoGarantia.tipo == 'F'
      @rhtml  = "fianza"
      @tipo = "Fianza Personal"
      @solicitud_avaluo_fianza = SolicitudAvaluoFianza.find(:first, :conditions=>['solicitud_avaluo_id = ? ', @solicitud_avaluo.id])
    end
  end

  protected
  def common
    super
    @form_title_record = 'Solicitudes'
    @form_title_records = 'Solicitudes'
    @form_entity = 'El Aspecto'
    #@form_identity_field = 'numero'
    @width_layout = '960'
  end

  private
  def municipio_fill(estado_id)
    @municipio_select = Municipio.find_all_by_estado_id(estado_id, :order=>'nombre')
    if @solicitud_avaluo.nil? || @solicitud_avaluo.Municipio.nil?
      municipio_id = @municipio_select.first.id
    else
      municipio_id = @solicitud_avaluo.Municipio.id
    end
    parroquia_fill(municipio_id)
  end

  def parroquia_fill(municipio_id)
    @parroquia_select = Parroquia.find_all_by_municipio_id(municipio_id, :order=>'nombre')
  end

  def save(archivo,solicitud_id,solicitud_tipo_garantia_id, solicitud_avaluo_imagen_1)
    name = archivo['datafile']
    unless name.class.name == "String"
      name = name.original_filename
      ext  =  name[(name.length - 3),name.length].to_s.upcase
      if ext == 'JPG' || ext == 'JPEG' || ext == 'PNG'
        directory = "tmp"
        path = File.join(directory, name)
        File.open(path, "wb") { |f| f.write(archivo['datafile'].read) }
        nombre_archivo = "sol" + solicitud_id.to_s
        resultado = SolicitudAvaluoImagen.crear_registro(nombre_archivo, name, solicitud_tipo_garantia_id, solicitud_avaluo_imagen_1)
        if resultado.class.name == "Fixnum"
          nombre_archivo << 'id' << resultado.to_s << '.' << ext.downcase
          File.copy("#{RAILS_ROOT}/tmp/#{name}", "#{RAILS_ROOT}/public/documentos/images_avaluo/#{nombre_archivo}")
          SolicitudAvaluoImagen.update_nombre_archivo(resultado,nombre_archivo)
          return true
        else
          return "<h2>Ha ocurrido un error</h2><p><UL>#{resultado}</UL></p>"
        end
      else
        return "<h2>Ha ocurrido un error</h2><p><UL><LI>El archivo no tiene el formato correcto (jpg, jpeg, png)</LI></UL></p>"
      end
    else
      return "<h2>Ha ocurrido un error</h2><p><UL><LI>Debe seleccionar el archivo a procesar</LI></UL></p>"
    end
  end

  def borrar_imagen(id)
    solicitud_avaluo_imagen = SolicitudAvaluoImagen.find(id)
    solicitud_tipo_garantia_id = solicitud_avaluo_imagen.solicitud_tipo_garantia_id
    File.delete("#{RAILS_ROOT}/public/documentos/images_avaluo/#{solicitud_avaluo_imagen.nombre_imagen}")
    solicitud_avaluo_imagen.destroy
    return solicitud_tipo_garantia_id
  end

end

