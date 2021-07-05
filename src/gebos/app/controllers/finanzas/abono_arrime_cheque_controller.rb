# encoding: utf-8

#
# autor: Marvin Alfonzo
# clase: Finanzas::AbonoArrimeChequeController
# descripción: Migración a Rails 3
#


class Finanzas::AbonoArrimeChequeController < FormTabsController

  layout 'form_basic'

skip_before_filter :set_charset, :only=>[:total_filtro, :estado_change, :sector_change, :entidad_financiera_change]  
  
  def index

    fill()
    @estado = Estado.find(:all, :order => 'nombre')
    @municipio = Municipio.find(:all, :order => 'nombre')
    @sector = Sector.find(:all, :conditions=>"activo=true", :order => 'nombre')
    @rubro = Rubro.find(:all, :conditions=>"activo=true",:order => 'nombre')

  end

  def list

    params['sort'] = "nro_tramite" unless params['sort']
    @condition = "nro_tramite > 0 and estatus_excedente = 30000 and numero_cuenta is null"

    unless params[:estado_id].nil? 
      unless params[:estado_id][0].to_s==''      
        @condition << " and estado_id = #{params[:estado_id][0]} "
        @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.estado_igual')} '#{Estado.find(params[:estado_id][0]).nombre}'"
      end
    end

    unless params[:sector_id].nil? 
      unless params[:sector_id][0].to_s==''            
        @condition << " and sector_id = #{params[:sector_id][0]} "
        @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.sector_igual')} '#{Sector.find(params[:sector_id][0]).nombre}'"
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
        @condition << " and rubro_id = #{params[:rubro_id][0]} "
        @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.rubro_igual')} '#{Rubro.find(params[:rubro_id][0]).nombre}'"
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

    unless params[:cedula_rif].to_s == '' ||  params[:cedula_rif].to_s.nil?
      @condition << " AND cedula_rif = '#{params[:tipo].to_s}#{params[:cedula_rif].to_s}' "   
	    @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.cedula_rif_contenga')} '#{params[:tipo].to_s}#{params[:cedula_rif]}'"   
    end

    unless params[:nombre].to_s == '' || params[:nombre].to_s.nil?
      @condition += " AND LOWER(beneficiario) LIKE '%#{params[:nombre].strip.downcase}%'"      
      @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.nombre_beneficiario')} '#{params[:nombre]}'"
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
    @condition = " and nro_tramite > 0 and estatus_excedente = 30000 and numero_cuenta is null "
    @total_filtro = ViewExcedenteArrime.count(:conditions=>params[:consulta] << @condition)
    logger.debug "pruebass de total filtro ->>>>>>>" << @condition
    render :update do |page|
        page.hide 'errorExplanation'
        page.replace_html 'desembolso_cheque_cantidad_total_filtro', :partial => 'cantidad_total_filtro'        
        page.show 'desembolso_cheque_cantidad_total_filtro'        
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
    @sector_select = Sector.find(:all, :conditions=>"activo=true", :order=>'nombre')
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

    @municipio_list =[]
    if @municipio_list.length == 0
       @municipio_list = []
    end

    @entidad_financiera_select = EntidadFinanciera.find(:all, :conditions=>"activo=true", :order=>'nombre')

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

  def preparar_cheque
    if params[:accion].nil?
      nombre = ''

      @condition = " and nro_tramite > 0 and estatus_excedente = 30000 and numero_cuenta is null "
      condiciones = params[:parametros_div] <<  @condition
      entidad_financiera_id = params[:id_entidad_financiera][0].to_i

      modalidad = params[:cheque]
      cuenta_bcv_fondas = params[:cuenta_bcv_fondas_sel][0]  #verificar
      items=params[:items_id]

      #`script/runner "ViewExcedenteArrime.generar_cheque(#{entidad_financiera_id.to_s},'#{modalidad.to_s}','#{condiciones.to_s}','#{cuenta_bcv_fondas}','#{items}')"`
      view_excedente=ViewExcedenteArrime.find(:first) 
      view_excedente.generar_cheque(entidad_financiera_id.to_s,modalidad.to_s,condiciones.to_s,cuenta_bcv_fondas,items)
    end
      @mostrar_archivo = ControlEnvioAbonoExcedenteCosecha.find(:all, :conditions=>" estatus = 1 and upper(archivo) like '%CHEQUE%' ",:order=>"id desc")
      
  end


  def common
   super   
   @form_title = I18n.t('Sistema.Body.Modelos.ViewExcedenteArrime.Mensajes.cheque_excedente_arrime')
   @form_title_record = I18n.t('Sistema.Body.Vistas.General.desembolso')
   @form_title_records = 'desembolsos'
   @form_entity = 'desembolso'
   @form_identity_field = 'id'
   @width_layout = '1140'
 end

end
