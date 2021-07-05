# encoding: utf-8
#
# autor: Luis Rojas
# clase: Solicitudes::AsignarMaquinariaController
# descripción: Migración a Rails 3
#
class Solicitudes::AsignarMaquinariaController < FormTabsController

  skip_before_filter :set_charset, :only=>[:asignar_catalogo, :change_serial, :estado_change, :municipio_change,:clase_search,:avanzar]
  
  layout 'form_basic'

  def index
    @municipio_list = Municipio.find(:all, :conditions=>['estado_id = ?', @usuario.oficina.ciudad.estado.id])
    @estado_list = Estado.find(:all, :order => 'nombre')
    municipio_fill(0)
  end

  def edit
    @solicitud = Solicitud.find(params[:id])
    @solicitud_maquinaria_list = SolicitudMaquinaria.find(:all, :conditions => ["solicitud_id = ? and estatus = 'I'", @solicitud.id], :order => 'tipo_maquinaria_id')
  end
  
  def asignar
    @solicitud_maquinaria = SolicitudMaquinaria.find(:first, :conditions => ["id = ?", params[:id]])
    @solicitud = Solicitud.find(@solicitud_maquinaria.solicitud_id)
    @catalogo_list = Catalogo.find(:all, :conditions => "id not in (#{@solicitud_maquinaria.catalogo_id}) and estatus = 'L' and clase_id = #{@solicitud_maquinaria.clase_id} and marca_maquinaria_id = #{@solicitud_maquinaria.marca_maquinaria_id} and modelo_id = #{@solicitud_maquinaria.modelo_id}")
  end
  
  def change_serial
    solicitud_maquinaria = SolicitudMaquinaria.find(:first, :conditions => ["id = ?", params[:id]])
    catalogo = Catalogo.find(solicitud_maquinaria.catalogo_id)
    catalogo.solicitud_id = nil
    catalogo.estatus = 'L'
    catalogo.save
    solicitud_maquinaria.catalogo_id = params[:catalogo_id]
    solicitud_maquinaria.save
    catalogo = Catalogo.find(params[:catalogo_id])
    catalogo.solicitud_id = solicitud_maquinaria.solicitud_id
    catalogo.estatus = 'R'
    catalogo.save
    flash[:notice] = "#{I18n.t('Sistema.Body.Vistas.General.los')} #{I18n.t('Sistema.Body.Vistas.General.seriales')} #{I18n.t('Sistema.Body.Vistas.General.se_modificaron')}"
    render :update do |page|
      page.redirect_to :action=>'edit', :id => solicitud_maquinaria.solicitud_id
    end
  end

  def plan_inventario
    @solicitud = Solicitud.find(params[:solicitud_id])
    @contrato_maquinaria_equipo = ContratoMaquinariaEquipo.find(:all)
    @tipo_maquinaria            = TipoMaquinaria.find(:all, :conditions=>'activo=true', :order=>'nombre asc')
    @clase                      = Clase.find(:all)
  end
  
  def sras
    @solicitud = Solicitud.find(params[:solicitud_id])
    @prestamo = Prestamo.find(:first, :conditions => "solicitud_id = #{@solicitud.id}")
    @gastos = ProgramaTipoGasto.find_by_programa_id_and_tipo_gasto_id(@solicitud.programa_id, 1)
  end

  def buscar
    conditions=" estatus='L' "

    @params['sort'] = "serial" unless @params['sort']

    unless params[:catalogo][:contrato_maquinaria_equipo_id].nil? || params[:catalogo][:contrato_maquinaria_equipo_id].to_s.empty?
      contrato_maquinaria_equipo_id = params[:catalogo][:contrato_maquinaria_equipo_id].to_s
      contrato = ContratoMaquinariaEquipo.find(contrato_maquinaria_equipo_id)
      conditions = " #{conditions} AND contrato_maquinaria_equipo_id = " + contrato_maquinaria_equipo_id
      #@form_search_expression << "Contrato es igual '#{contrato.nombre}'"
    end


    unless params[:tipo_maquinaria][:id].nil? || params[:tipo_maquinaria][:id].to_s.empty?
      tipo_id = params[:tipo_maquinaria][:id].to_s
      tipomaquinaria = TipoMaquinaria.find(tipo_id)
      conditions = " #{conditions} AND clase.tipo_maquinaria_id = " + tipo_id
      #@form_search_expression << "Tipo es igual '#{tipomaquinaria.nombre}'"
    end

    unless params[:catalogo][:clase_id].nil? || params[:catalogo][:clase_id].to_s.empty?
      clase_id = params[:catalogo][:clase_id].to_s
      clase = Clase.find(clase_id)
      conditions = " #{conditions} AND clase_id = " + clase_id
      #@form_search_expression << "Clase es igual '#{clase.nombre}'"
    end
    
    unless params[:catalogo][:serial].nil? || params[:catalogo][:serial].to_s.empty?
      conditions = " #{conditions} AND (lower(serial) = lower('#{params[:catalogo][:serial]}') or chasis = lower('#{params[:catalogo][:serial]}')"
      #@form_search_expression << "Clase es igual '#{clase.nombre}'"
    end

    @list = Catalogo.search_especial(conditions, params[:page], params[:sort]," INNER JOIN clase ON clase.id = catalogo.clase_id INNER JOIN tipo_maquinaria ON  tipo_maquinaria.id=clase.tipo_maquinaria_id", 'catalogo.*,clase.tipo_maquinaria_id')
    @total=@list.count

    form_list
  end

  def list_inventario
    conditions=" estatus='L' "

    @params['sort'] = "serial" unless @params['sort']

    unless params[:catalogo][:contrato_maquinaria_equipo_id].nil? || params[:catalogo][:contrato_maquinaria_equipo_id].to_s.empty?
      contrato_maquinaria_equipo_id = params[:catalogo][:contrato_maquinaria_equipo_id].to_s
      contrato = ContratoMaquinariaEquipo.find(contrato_maquinaria_equipo_id)
      conditions = " #{conditions} AND contrato_maquinaria_equipo_id = " + contrato_maquinaria_equipo_id
      #@form_search_expression << "Contrato es igual '#{contrato.nombre}'"
    end


    unless params[:tipo_maquinaria][:id].nil? || params[:tipo_maquinaria][:id].to_s.empty?
      tipo_id = params[:tipo_maquinaria][:id].to_s
      tipomaquinaria = TipoMaquinaria.find(tipo_id)
      conditions = " #{conditions} AND clase.tipo_maquinaria_id = " + tipo_id
      #@form_search_expression << "Tipo es igual '#{tipomaquinaria.nombre}'"
    end

    unless params[:catalogo][:clase_id].nil? || params[:catalogo][:clase_id].to_s.empty?
      clase_id = params[:catalogo][:clase_id].to_s
      clase = Clase.find(clase_id)
      conditions = " #{conditions} AND clase_id = " + clase_id
      #@form_search_expression << "Clase es igual '#{clase.nombre}'"
    end
    
    unless params[:catalogo][:serial].nil? || params[:catalogo][:serial].to_s.empty?
      conditions = " #{conditions} AND (lower(serial) = lower('#{params[:catalogo][:serial]}') or chasis = lower('#{params[:catalogo][:serial]}')"
      #@form_search_expression << "Serial Motor es igual '#{params[:catalogo][:serial]}' o Serial Chasis es igual '#{params[:catalogo][:serial]}"
    end

    @list = Catalogo.search_especial(conditions, params[:page], params[:sort]," INNER JOIN clase ON clase.id = catalogo.clase_id INNER JOIN tipo_maquinaria ON  tipo_maquinaria.id=clase.tipo_maquinaria_id", 'catalogo.*,clase.tipo_maquinaria_id')
    @total=@list.count
   

    form_list 'list_inventario'
  end


  def delete
    @catalogo_serial = Catalogo.find_by_id(params[:catalogo_id]).serial
    PlanInventario.actualizar_prestamo(params[:catalogo_id])
    @prestamo = Prestamo.find_by_solicitud_id(params[:solicitud_id])

    tipo_maquinaria=TipoMaquinaria.find(:all, :conditions=>'activo=true', :order=>'nombre asc')
    render :update do |page|
      tipo_maquinaria.each { |x|
        joins= " INNER JOIN clase ON clase.id=catalogo.clase_id and clase.tipo_maquinaria_id=#{x.id.to_s} "
        @catalogo = Catalogo.find(:all,:joins=>joins, :conditions=>["solicitud_id=#{params[:solicitud_id]}"] ,:include=>['contrato_maquinaria_equipo','clase'])
        @nombre_tipo_maquinaria = x.nombre
        @tipo_maquinaria_id = x.id
        page.replace_html 'list-inventario-' + x.id.to_s, :partial => 'list_inventario', :solicitud_id => params[:solicitud_id], :tipo_maquinaria_id => x.id
      }
      page.replace_html 'total-prestamo', :partial=>'total_prestamo'
      #      page.remove "row_#{params[:catalogo_id]}"
      page.replace_html 'message_inventario', "Se eliminó el item del trámite"
      page.show 'message_inventario'
      page.hide 'message_catalogo'
    end
  end

  def clase_search
    if !params[:id].nil? && !params[:id].empty?
      @clase = Clase.find(:all, :conditions=>["tipo_maquinaria_id = ?", params[:id].to_s],:order=>"nombre",:select=>"id,nombre,activo")
      render :update do |page|
        page.replace_html 'clase-search', :partial => 'clase_search'
        page.show 'tr_clase_search'
      end
    else
      render :update do |page|
        page.hide 'tr_clase_search'
      end
    end
  end

  def asignar_catalogo
    if PlanInventario.validar(params[:solicitud_id]) == true
      @solicitud = Solicitud.find(params[:solicitud_id])
      @error = PlanInventario.validar_libres(params)
      @catalogo_serial_agregar = PlanInventario.asignar_catalogo_inventario(params,session, @usuario.id)
      @prestamo = Prestamo.find_by_solicitud_id(params[:solicitud_id])

      tipo_maquinaria=TipoMaquinaria.find(:all, :conditions=>'activo=true', :order=>'nombre asc')
      mensaje = ""
      if @catalogo_serial_agregar.length > 0
        mensaje = "Se agregó el item al trámite  <br/>"
      else
        mensaje = "No se pudo agregar los items"
      end
      if @error.length > 0
        mensaje << "No se pudo agregar el item con el serial: << <span style='color:red;'>#{@error.to_s}</span> >> ya que el estatus es <span style='color:red;'>Reservado</span>"
      end
      catalogo_id = params[:catalogo_id].to_s.split(",")
      render :update do |page|
        tipo_maquinaria.each { |x|
          joins= " INNER JOIN clase ON clase.id=catalogo.clase_id and clase.tipo_maquinaria_id=#{x.id.to_s} "
          @catalogo = Catalogo.find(:all,:joins=>joins, :conditions=>["solicitud_id=#{params[:solicitud_id]}"] ,:include=>['contrato_maquinaria_equipo','clase'])
          @nombre_tipo_maquinaria = x.nombre
          @tipo_maquinaria_id = x.id
          page.replace_html 'list-inventario-' + x.id.to_s, :partial => 'list_inventario', :solicitud_id => params[:solicitud_id], :tipo_maquinaria_id => x.id
          page.replace_html 'total-prestamo', :partial=>'total_prestamo'
        }
        catalogo_id.each{ |e|
          page.remove "row_#{e}"
        }
        page.<< "document.getElementById('catalogo_id').value = '';"
        if mensaje.length > 0
          page.replace_html 'message_catalogo', mensaje
          page.show 'message_catalogo'
          page.hide 'message_inventario'
        end
      end
    else
      render :update do |page|
        page.alert "Debe configurar las condiciones de financiamiento para realizar esta operación."
      end
    end
  end

  def estado_change
    municipio_fill(params[:estado_id])
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

  def avanzar
    resultado = SolicitudMaquinaria.avanzar(params[:id], @usuario)
    if resultado.length > 0
      render :update do |page|
        page.hide 'message'
        page.hide 'error'
        page.replace_html 'errorExplanation','<h2>Ha ocurrido un error</h2><p><UL>' << resultado << '</UL></p>'
        page.show 'errorExplanation'
        page.<< "window.scrollTo(0,0);"
      end
      return
    else
      @solicitud = Solicitud.find(params[:id])
      render :update do |page|
        page.remove "row_#{@solicitud.id}"
        page.hide 'error'
        page.replace_html 'message', "La Solicitud Número #{@solicitud.numero} fue Enviada al técnico de campo con éxito."
        page.show 'message'
      end
    end
  end

  def list
    conditions = "solicitud_id in (select id from solicitud where por_inventario = true)"
    params['sort'] = "numero" unless params['sort']

    unless params[:estado_id].nil? 
      unless params[:estado_id][0].to_s==''      
      conditions = "#{conditions} and estado_id = #{params[:estado_id][0]} "
      #@form_search_expression << "Estado es igual '#{estado.nombre}'"
      end
    end
    
    unless params[:municipio_id].nil?
      unless params[:municipio_id][0].to_s==''            
      conditions = "#{conditions} and municipio_id = #{params[:municipio_id][0]} "
      #@form_search_expression << "Municipio es igual '#{municipio.nombre}'"
      end
    end

    unless params[:parroquia_id].nil?
      unless params[:parroquia_id][0].to_s==''            
      conditions = "#{conditions} and parroquia_id = #{params[:parroquia_id][0]} "
      #@form_search_expression << "Parroquia es igual '#{parroquia.nombre}'"
      end
    end

    unless params[:unidad_produccion].nil? ||  params[:unidad_produccion].empty?
      conditions = "#{conditions} and lower(unidad_produccion) LIKE lower('%#{params[:unidad_produccion].strip}%') "
      #@form_search_expression << "Unidad de Producción contenga '#{params[:unidad_produccion]}'"
    end
    
    unless params[:identificacion].nil? ||  params[:identificacion].empty?
      conditions = "#{conditions} AND lower(cedula_rif) = lower('#{params[:identificacion]}')"
      #@form_search_expression << "Rif o Cédula igual '#{params[:identificacion]}'"
    end
    
    unless params[:numero].nil? || params[:numero].empty?
      conditions = "#{conditions} AND (numero =  #{params[:numero].to_i})"
      #@form_search_expression << "Número igual '#{params[:numero]}'"
    end
    
    unless params[:nombre].nil? || params[:nombre].empty?
      conditions = "#{conditions} AND LOWER(beneficiario) LIKE  '%#{params[:nombre].strip.downcase}%'"
      #@form_search_expression << "Nombre del Beneficiario contenga '#{params[:nombre]}'"
    end

    @list = ViewAsignarMaquinaria.search(conditions, params[:page], params[:sort])
    @total=@list.count

    condicion_rol = " usuario_rol.rol_id = 7 "
    @aux_roles = @usuario.roles.find(:first, :conditions=>condicion_rol)
    
    form_list
  end
	
  protected
  def common
    super
    @form_title = "#{I18n.t('Sistema.Body.Vistas.General.modificando')} #{I18n.t('Sistema.Body.Vistas.General.seriales')}"
    @form_title_record = 'Trámites'
    @form_title_records = 'Trámites'
    @form_entity = 'consulta_solicitud'
    @form_identity_field = 'numero'
    @width_layout = '1200'
  end

  private
  def municipio_fill(estado_id)
    @municipio_list = Municipio.find_all_by_estado_id(estado_id, :order=>'nombre')
    parroquia_fill(0)
  end

  def parroquia_fill(municipio_id)
    @parroquia_list = Parroquia.find_all_by_municipio_id(municipio_id, :order=>'nombre')
  end
  
end
