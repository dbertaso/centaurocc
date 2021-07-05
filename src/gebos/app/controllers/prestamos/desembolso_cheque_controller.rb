# encoding: utf-8
#
# autor: Marvin Alfonzo
# clase: Prestamos::DesembolsoChequeController
# descripción: Migración a Rails 3
#

class Prestamos::DesembolsoChequeController < FormTabsController

skip_before_filter :set_charset, :only=>[:entidad_financiera_change, :sector_change, :estado_change, :total_filtro]

  layout 'form_basic'

  def index

    fill()
    @estado = Estado.find(:all, :order => 'nombre')
    @municipio = Municipio.find(:all, :order => 'nombre')
    @sector = Sector.find(:all,:conditions=>"activo=true", :order => 'nombre')
    @rubro = Rubro.find(:all,:conditions=>"activo=true", :order => 'nombre')
    @moneda_list = Moneda.find(:all, :conditions=> "activo = true", :order => "nombre")
  end

  def list

    params['sort'] = "nro_tramite" unless params['sort']
    @condition = "nro_tramite > 0"

    unless params[:estado_id].nil? 
      unless params[:estado_id][0].to_s==''
        estado_id = params[:estado_id][0].to_s      
        @condition << " and estado_id = #{estado_id} "
        @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.estado_igual')} '#{Estado.find(estado_id).nombre}'"      
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

    unless params[:cedula_rif].to_s == '' ||  params[:cedula_rif].to_s.nil?
      @condition << " AND cedula_rif = '#{params[:tipo].to_s}#{params[:cedula_rif].to_s}' "
      @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.cedula_rif_contenga')} '#{params[:tipo].to_s}#{params[:cedula_rif]}'"      
    end

    unless params[:nombre].to_s == '' || params[:nombre].to_s.nil?
      @condition += " AND LOWER(beneficiario) LIKE '%#{params[:nombre].strip.downcase}%'"      
      @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.nombre_apellido')} '#{params[:nombre]}'"
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

    
    @list = ViewListDesembolsoCheque.search(@condition, params[:page], params['sort'])    
    @total=@list.count

    @condition1 = params[:escon].to_s
    logger.debug "pruebass del list ->>>>>>>" << params.inspect.to_s

    form_list

  end

  def total_filtro
    @total_filtro = ViewListDesembolsoCheque.count(:conditions=>params[:consulta])
    logger.debug "pruebass de total filtro ->>>>>>>" << params[:consulta]
    render :update do |page|
        page.hide 'errorExplanation'
        page.replace_html 'desembolso_cheque_cantidad_total_filtro', :partial => 'cantidad_total_filtro'        
        page.show 'desembolso_cheque_cantidad_total_filtro'
        #page.show 'message'
        #page.<< "window.scrollTo(0,200);"
      end
  end


  def estado_change

    @municipio_list = Municipio.find(:all, :conditions=>"estado_id = #{params[:id]}", :order=> "nombre")

    render :update do |page|
      page.replace_html 'municipio-select', :partial => 'municipio_select'
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

    @municipio_list =[]
    if @municipio_list.length == 0
       @municipio_list = []
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


  def preparar_cheque

    logger.info"XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXxx"<<params[:accion].inspect
    if params[:accion].nil?
    nombre = ''

    logger.info "Parametros ===> " << params.inspect
    condiciones = params[:parametros_div]
    entidad_financiera_id = params[:id_entidad_financiera][0].to_i

    modalidad = params[:cheque]
    logger.info 'MODALIDAD 111  ====> ' << modalidad.to_s
    cuenta_bcv_fondas = params[:cuenta_bcv_fondas_sel][0] #verificar
    items=params[:items_id]

    logger.info 'MODALIDAD 111  ====> ' << modalidad.to_s
    logger.info 'PARAMETROS_DIV =================>> ' << condiciones.to_s

    logger.info 'Parametros      ====> ' << params.inspect

#      Desembolso.generar_cheque(entidad_financiera_id.to_s,modalidad.to_s,condiciones.to_s,cuenta_bcv_fondas, items)

  #  logger.info "Entrando al script/runner con ====> " << "Desembolso.generar_cheque(#{modalidad.to_s},#{condiciones.to_s},#{cuenta_bcv_fondas},#{items})"
   # `script/runner "Desembolso.generar_cheque(#{entidad_financiera_id.to_s},'#{modalidad.to_s}','#{condiciones.to_s}','#{cuenta_bcv_fondas}','#{items}')"`


desembolso=Desembolso.find(:first) 
desembolso.generar_cheque(entidad_financiera_id.to_i,modalidad.to_s,condiciones.to_s,cuenta_bcv_fondas,items,session[:id])

end

    @mostrar_archivo = ControlEnvioDesembolso.find(:all, :conditions=>" upper(archivo) like '%CHEQUE%'",:order=>"id desc")


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


  def common
   super
   #@form_title = Etiquetas.etiqueta(10)
   @form_title = I18n.t('Sistema.Body.Vistas.Form.liquidacion') << " / " << I18n.t('Sistema.Body.Vistas.General.cheques')
   @form_title_record = I18n.t('Sistema.Body.Vistas.Form.desembolso')
   @form_title_records = I18n.t('Sistema.Body.Vistas.ParametroGeneral.Separadores.desembolsos')
   @form_entity = 'desembolso'
   @form_identity_field = 'id'
   @width_layout = '1140'
 end

end
