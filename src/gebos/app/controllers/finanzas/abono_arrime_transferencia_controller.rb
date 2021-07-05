# encoding: utf-8

#
# autor: Marvin Alfonzo
# clase: Finanzas::AbonoArrimeTransferenciaController
# descripción: Migración a Rails 3
#


class Finanzas::AbonoArrimeTransferenciaController < FormTabsController

   layout 'form_basic'

skip_before_filter :set_charset, :only=>[:total_filtro, :sector_change, :entidad_financiera_change,:oficina_form_change]

  def index
    fill()
    @banco_origen = BancoOrigen.find(:all, :order => 'nombre')
    @estado = Estado.find(:all, :order => 'nombre')
    @oficina =[]
    #@oficina = Oficina.find(:all, :order => 'nombre')
    @sector = Sector.find(:all, :conditions=>"activo=true", :order => 'nombre')
    @rubro = Rubro.find(:all,:conditions=>"activo=true",:order => 'nombre')
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


  def list
     @total= ''
     params['sort'] = "nro_tramite" unless params['sort']
     @condition = "nro_tramite > 0 and estatus_excedente = 30000 and numero_cuenta is not null"

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

    #esta columna no existe en la vista view_excendente_arrime
    #unless params[:numero_desembolso].nil? || params[:numero_desembolso].empty?
    #  @condition << " AND numero_desembolso =  #{params[:numero_desembolso].to_i}"      
    #end

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


    
    @list = ViewExcedenteArrime.search(@condition, params[:page], params['sort'])    
    @total=@list.count
    @condition1 = params[:escon].to_s
    logger.debug "pruebass del list ->>>>>>>" << params.inspect.to_s

    form_list
  end

  def total_filtro
  @total_filtro = ViewExcedenteArrime.count(:conditions=>params[:consulta])
    logger.debug "pruebass de total filtro ->>>>>>>" << params[:consulta]
    render :update do |page|
        page.hide 'errorExplanation'
        page.replace_html 'desembolso_cantidad_total_filtro', :partial => 'cantidad_total_filtro'        
        page.show 'desembolso_cantidad_total_filtro'        
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


  @sector_select = Sector.find(:all, :conditions=>"activo=true",:order=>'nombre')
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

    @entidad_financiera_select = EntidadFinanciera.find(:all, :conditions=>"activo=true",:order=>'nombre')

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
    cuenta_bcv_fondas = params[:cuenta_bcv_fondas_sel][0] 
    fecha_valor = params[:fecha_valor_f]
    items=params[:items_id]
      
      view_excedente=ViewExcedenteArrime.find(:first) 
      view_excedente.generar_transferencias(entidad_financiera_id.to_s,tipo_archivo.to_s,condiciones.to_s,cuenta_bcv_fondas,fecha_valor,items)
   end
      @mostrar_archivo = ControlEnvioAbonoExcedenteCosecha.find(:all, :conditions=>" estatus = 1 and upper(archivo) not like '%CHEQUE%'  ",:order=>"id desc" )
  end

  def view
     @view_list_desembolso = ViewExcedenteArrime.find(:all)
  end

  def common
   super
   @form_title = I18n.t('Sistema.Body.Modelos.Factura.Tipo.abono_en_cuenta_excedente_arrime')
   @form_title_record = I18n.t('Sistema.Body.Vistas.General.financiamiento')
   @form_title_records = I18n.t('Sistema.Body.Vistas.General.financiamientos')
   @form_entity = 'abono'
   @form_identity_field = 'id'
   @records_by_page = 1000
   @width_layout = '1140'
 end

end
