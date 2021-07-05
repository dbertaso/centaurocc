# encoding: utf-8

#
# autor: Marvin Alfonzo
# clase: Prestamos::DesembolsoController
# descripción: Migración a Rails 3
#



class Prestamos::DesembolsoController < FormTabsController

skip_before_filter :set_charset, :only=>[:entidad_financiera_change, :sector_change, :total_filtro, :liquidar_cheque,:oficina_form_change]

  layout 'form_basic'

  def index
    fill()
    @banco_origen = BancoOrigen.find(:all, :order => 'nombre')
    @estado = Estado.find(:all, :order => 'nombre')
    @oficina =[]    
    @sector = Sector.find(:all, :conditions=>"activo=true",:order => 'nombre')
    @rubro = Rubro.find(:all, :conditions=>"activo=true",:order => 'nombre') 
    @cuenta_bcv_fondas=[]
    @moneda_list = Moneda.find(:all, :conditions=> "activo = true", :order => "nombre")
  end

  def oficina_form_change    
    unless params[:estado_id].to_s ==''
      @oficina = Oficina.find(:all, :conditions=>"ciudad_id in (select id from ciudad where estado_id = #{params[:estado_id]})", :order=> "nombre")    
    else
      @oficina =[]
    end
  
    render :update do |page|
      page.replace_html 'oficina-select', :partial => 'oficina_form_select'
    end  
  end

  def liquidar_cheque
    items = params[:items_id]
    total_tramite = 0
    sucede = 0
    plural =""
    msg_error = ""
    item = items.split(',')
    item.each { |i|
      desembolso = Desembolso.find(i)
      tramite = Solicitud.find(desembolso.solicitud_id)
      logger.debug "TRAMITE ID - NRO. "<< tramite.id.to_s << "-" << tramite.numero.to_s
      estatus_id_inicial = tramite.estatus_id
      estatus_id_final = 10055
      tramite.estatus_id = estatus_id_final

      success = true
      success &&= tramite.save
      if success
        total_tramite += 1
        # Crea un nuevo registro en la tabla control_solicitud
        ControlSolicitud.create_new(tramite.id, estatus_id_final, @usuario.id, I18n.t('Sistema.Body.Modelos.Desembolso.Estatus.trasladando_el_tramite_liquidacion_cheque'), estatus_id_inicial, I18n.t('Sistema.Body.Modelos.Desembolso.Estatus.trasladando_el_tramite_liquidacion_cheque'))
      else
        msg_error = msg_error << I18n.t('Sistema.Body.Modelos.DesembolsoDetalle.Errores.error_enviar_tramite',:numero=>tramite.numero)
        sucede += 1
      end

    }
    if total_tramite == 1
        plural = I18n.t('Sistema.Body.Modelos.Errores.tramite_sin_b')
    elsif total_tramite > 1
        plural = I18n.t('Sistema.Body.Modelos.Errores.tramites')
    end
    logger.info "SUCEDE =========> " << sucede.to_s
    if (sucede < 1)
        render :update do |page|
            page.redirect_to :action=>'index'
            page.hide 'errorExplanation'
            page.replace_html 'message', "#{I18n.t('Sistema.Body.Modelos.Desembolso.Estatus.se_han_eviado_con_exito')} #{total_tramite} #{plural} #{I18n.t('Sistema.Body.Modelos.Desembolso.Estatus.a_liquidacion_con_cheque')}"
            page.show 'message'
        end
    else
        render :update do |page|
          page.hide 'mensaje'
          page.replace_html 'errorExplanation',"<h2>#{I18n.t('Sistema.Body.General.ocurrio_error')}</h2><p><UL>" << msg_error
          page.show 'errorExplanation'
        end
        return false
    end
  end

  def list
    @total= ''

    #     @desembolso = ViewListDesembolso.find(:all)
    params['sort'] = "nro_tramite" unless params['sort']
    @condition = "nro_tramite > 0"
    #     conditions_totales = @conditions

    #    logger.debug "parametros del list->>>>>>> " << params.inspect

    unless params[:estado_id].nil? 
      unless params[:estado_id][0].to_s==''
        estado_id = params[:estado_id][0].to_s      
        @condition << " and estado_id = #{estado_id} "      
  	    @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.estado_igual')} '#{Estado.find(estado_id).nombre}'"
      end
    end

    unless params[:oficina_id].nil?
      unless params[:oficina_id][0].to_s==''
        oficina_id = params[:oficina_id][0].to_s
        @condition << " and oficina_id = #{oficina_id} "
        @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.oficina_igual')} '#{Oficina.find(oficina_id).nombre}'"
      end      
    end

    unless params[:sector_id].nil? 
      unless params[:sector_id][0].to_s==''
        sector_id = params[:sector_id][0].to_s      
        @condition << " and sector_id = #{sector_id} "
  	    @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.sector_igual')} '#{Sector.find(sector_id).nombre}'"
      end
    end

    unless params[:sub_sector_id].nil?
      unless params[:sub_sector_id][0].to_s==''
        sub_sector_id = params[:sub_sector_id][0].to_s      
        @condition << " and sub_sector_id = " + sub_sector_id    
        @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.sub_sector_igual')} '#{SubSector.find(sub_sector_id).nombre}'"  
      end
    
    end

    unless params[:rubro_id].nil? 
      unless params[:rubro_id][0].to_s==''
        rubro_id = params[:rubro_id][0].to_s      
        @condition << " and rubro_id = #{rubro_id} "
        @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.rubro_igual')} '#{Rubro.find(rubro_id).nombre}'"
      end
    end

    unless params[:sub_rubro_id].nil?
      unless params[:sub_rubro_id][0].to_s==''
        sub_rubro_id = params[:sub_rubro_id][0].to_s            
        @condition << " and sub_rubro_id = " + sub_rubro_id
        @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.sub_rubro_igual')} '#{SubRubro.find(sub_rubro_id).nombre}'"
      end
    end
    unless params[:actividad_id].nil? 
      unless params[:actividad_id][0].to_s==''
        actividad_id = params[:actividad_id][0].to_s      
        @condition << " and actividad_id = " + actividad_id
        @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.actividad_igual')} '#{Actividad.find(actividad_id).nombre}'"
      end
    end

    unless params[:numero_desembolso].nil? || params[:numero_desembolso].empty?
      @condition << " AND numero_desembolso =  #{params[:numero_desembolso].to_i}"      
      @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.numero_desembolso_igual')} '#{params[:numero_desembolso]}'"
    end

    unless params[:cedula_rif].to_s == '' ||  params[:cedula_rif].to_s.nil?
      @condition << " AND cedula_rif = '#{params[:tipo].to_s}#{params[:cedula_rif].to_s}' "   
      @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.cedula_rif_contenga')} '#{params[:tipo].to_s}#{params[:cedula_rif]}'"   
    end
    
    unless params[:entidad_financiera_id].nil? 
      unless params[:entidad_financiera_id][0].to_s==''
        entidad_financiera_id = params[:entidad_financiera_id][0].to_s      
        @condition << " and entidad_financiera_id = #{entidad_financiera_id} "
        @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.entidad_financiera_igual')} '#{EntidadFinanciera.find(entidad_financiera_id).nombre}'"
      end
    end

    unless params[:nro_tramite].nil? || params[:nro_tramite].empty?
      @condition << " AND nro_tramite =  #{params[:nro_tramite].to_i}"      
      @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.numero_tramite')} '#{params[:nro_tramite]}'"
    end
    
    unless params[:moneda_id][0].blank?
      moneda = Moneda.find(params[:moneda_id][0])
      @condition << " AND moneda_id = '#{params[:moneda_id][0].to_i}' "      
      @form_search_expression << "#{I18n.t('Sistema.Body.Vistas.General.moneda')} #{I18n.t('Sistema.Body.Vistas.General.igual')} '#{moneda.nombre}'"
    end

    
    @list = ViewListDesembolso.search(@condition, params[:page], params['sort'])    
    @total=@list.count

    @condition1 = params[:escon].to_s
    logger.debug "pruebass del list ->>>>>>>" << params.inspect.to_s

    form_list
  end

  def total_filtro
    @total_filtro = ViewListDesembolso.count(:conditions=>params[:consulta])
    logger.debug "pruebass de total filtro ->>>>>>>" << params[:consulta]
    render :update do |page|
      page.hide 'errorExplanation'
      page.replace_html 'desembolso_cantidad_total_filtro', :partial => 'cantidad_total_filtro'     
      page.show 'desembolso_cantidad_total_filtro'
    #page.show 'message'
    #page.<< "window.scrollTo(0,200);"
    end
  end

  def sector_change

    @rubro_list = Rubro.find(:all, :conditions=>"activo=true and sector_id = #{params[:id]}", :order=> "nombre")

    render :update do |page|
      page.replace_html 'rubro-select', :partial => 'rubro_select'
    end
  end

  def entidad_financiera_change    
    unless params[:id].to_s ==''
      @cuenta_bcv_fondas = CuentaBcv.find(:all, :conditions=>"activo=true and entidad_financiera_id = #{params[:id]}", :order=> "numero")
    else
      @cuenta_bcv_fondas =[]
    end
    render :update do |page|
      page.replace_html 'cuenta_bcv-select', :partial => 'cuenta_bcv_select'
    end
  end
 

  def fill

    @sector_select = Sector.find(:all,:conditions=>"activo=true", :order=>'nombre')
    sub_sector_fill(0)
    rubro_fill(0)
    sub_rubro_fill(0)
    actividad_fill(0)

    if @sector_select.length == 0
    @sector_select = []
    end

   
    @rubro_list=[]
    if @rubro_list.length == 0
    @rubro_list = []
    end

    @estado_select = Estado.find(:all , :order =>'nombre')

    if @estado_select.length == 0
    @estado_select = []
    end

    @oficina_select = Oficina.find(:all, :order=>'nombre')

    if @oficina_select.length == 0
    @oficina_select = []
    end

    @entidad_financiera_select = EntidadFinanciera.find(:all,:conditions=>"activo=true", :order=>'nombre')

    if @entidad_financiera_select.length == 0
    @entidad_financiera_select = []
    end

    @cuenta_bcv_fondas =[]
    if @cuenta_bcv_fondas.length == 0
    @cuenta_bcv_fondas = []
    end

  end

  def sub_sector_fill(sector_id)
    @sub_sector_list = SubSector.find(:all, :conditions=>['activo=true and sector_id = ?', sector_id], :order => 'nombre')
    rubro_fill(0)
    sub_rubro_fill(0)
    actividad_fill(0)
  end

  def rubro_fill(sub_sector_id)
    @rubro_list = Rubro.find(:all, :conditions=>['activo=true and sub_sector_id = ?', sub_sector_id], :order => 'nombre')
    sub_rubro_fill(0)
    actividad_fill(0)
  end

  def sub_rubro_fill(rubro_id)
    @sub_rubro_list = SubRubro.find(:all, :conditions=>['activo=true and rubro_id = ?', rubro_id], :order => 'nombre')
    actividad_fill(0)
  end

  def actividad_fill(sub_rubro_id)
    @actividad_list = Actividad.find(:all, :conditions=>['activo=true and sub_rubro_id = ?', sub_rubro_id], :order => 'nombre')
  end

  def preparar_trasnferencia


    if params[:accion].nil?
    nombre = ''

    logger.info "Parametros ===> " << params.inspect
    condiciones = params[:parametros_div]
    entidad_financiera_id = params[:id_entidad_financiera][0].to_i

    tipo_archivo = params[:txt]
    cuenta_bcv_fondas = params[:cuenta_bcv_fondas_sel][0] #verificar
    fecha_valor = params[:fecha_valor_f]
    items=params[:items_id]

    logger.info 'Entidad Financiera ====> ' << entidad_financiera_id.to_s

    logger.info 'Parametros      ====> ' << params.inspect

    #      Desembolso.generar_transferencias(entidad_financiera_id.to_s,tipo_archivo.to_s,condiciones.to_s,cuenta_bcv_fondas, fecha_valor,items)

   # logger.info "Entrando al script/runner con ====> " << "Desembolso.generar_transferencias(#{tipo_archivo.to_s},#{condiciones.to_s},#{cuenta_bcv_fondas},#{fecha_valor},#{items})"
   # `script/runner "Desembolso.generar_transferencias(#{entidad_financiera_id.to_s},'#{tipo_archivo.to_s}','#{condiciones.to_s}','#{cuenta_bcv_fondas}','#{fecha_valor}','#{items}')"`

desembolso=Desembolso.find(:first) 

desembolso.generar_transferencias(entidad_financiera_id.to_i,tipo_archivo.to_s,condiciones.to_s,cuenta_bcv_fondas,fecha_valor,items,session[:id])


end
    @mostrar_archivo = ControlEnvioDesembolso.find(:all, :conditions=>" upper(archivo) like '%PROV%'",:order=>"id desc" ) # MODIFICACION PARA QUE NO SE MUESTRESN TODOS LOS ARCHIVOS EN LA BANDEJA ARCHIVOS PROCESADOS EN TRANSFERENCIA
    #redirect_to :preparar_trasnferencia

  end

  def view  
    @view_list_desembolso = ViewListDesembolso.find(:all)  
  end

  

  def common
    super
    #@form_title = Etiquetas.etiqueta(10)
    @form_title = "#{I18n.t('Sistema.Body.Vistas.Form.liquidacion')} / #{I18n.t('Sistema.Body.Vistas.General.transferencia')}"
    @form_title_record = I18n.t('Sistema.Body.Vistas.Form.desembolso')
    @form_title_records = I18n.t('Sistema.Body.Vistas.ParametroGeneral.Separadores.desembolsos')
    @form_entity = 'desembolso'
    @form_identity_field = 'id'
    @records_by_page = 1000
    @width_layout = '1300'
  end

end
