# encoding: utf-8
#
# autor: Luis Rojas
# clase: Clientes::ClientePersonaController
# descripción: Migración a Rails 3
#

class Clientes::ClientePersonaController < FormTabsController
  
  skip_before_filter :set_charset, :only=>[:check_new]

  layout 'form_basic'

  def list
  
    params['sort'] = "primer_nombre" unless params['sort']
    conditions = 'id > 0'
    unless params[:cedula].nil? || params[:cedula].empty?
      conditions << " AND cedula = " << params[:cedula].to_i.to_s
      @form_search_expression << "Cédula sea igual '#{params[:cedula]}'"
    end
    unless (params[:primer_nombre].nil? || params[:primer_nombre].empty?)
      conditions << " AND LOWER(primer_nombre) LIKE '%#{params[:primer_nombre].strip.downcase}%'"
      @form_search_expression << "Primer Nombre contenga '#{params[:primer_nombre]}'"
    end
    unless (params[:primer_apellido].nil? || params[:primer_apellido].empty?)
      conditions << " AND LOWER(primer_apellido) LIKE '%#{params[:primer_apellido].strip.downcase}%'"
      @form_search_expression << "Primer Apellido contenga '#{params[:primer_apellido]}'"
    end
    
    
    @list = Persona.search(conditions, params[:page], params[:sort])
    @total=@list.count

    form_list

  end
	
	def check_new
    unless params[:cedula].blank?
      cedula = params[:cedula].to_i.to_s
      if cedula.length == params[:cedula].length
        persona = Persona.count(:conditions => 'cedula = ' + params[:cedula].to_i.to_s)
        if persona > 0
          render :update do |page|
            page.alert " #{I18n.t('Sistema.Body.Vistas.General.con')} #{I18n.t('Sistema.Body.Vistas.General.la')} #{I18n.t('Sistema.Body.Vistas.General.cedula')}  #{params[:cedula].to_i.to_s} #{I18n.t('Sistema.Body.Modelos.Errores.ya_existe')}"
          end
          return
        else
          render :update do |page|
            page.redirect_to :action=>'new', :cedula=>params[:cedula].to_i, :popup=>params[:popup]
          end
        end
      else
        render :update do |page|
          page.alert "#{I18n.t('Sistema.Body.Vistas.General.nro')} #{I18n.t('Sistema.Body.Vistas.General.cedula')} #{I18n.t('Sistema.Body.Modelos.Errores.numero_invalido')}"
        end
        return
      end
    else
      render :update do |page|
        page.alert "#{I18n.t('Sistema.Body.Vistas.General.nro')} #{I18n.t('Sistema.Body.Vistas.General.cedula')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"
      end
      return
    end
	end
	
  def new
    @persona = Persona.new
    @persona.cedula = params[:cedula]
    @persona.estado_civil = 'S'
    @persona.sexo = false
    @cliente_persona = ClientePersona.new
    fill
  end
  
  def save_new
    if params[:id] && !params[:id].empty?
      @persona = Persona.find(params[:id])
      @cliente_persona = ClientePersona.find(@persona.cliente_id)
    else
      @persona = Persona.new(params[:persona])
      @cliente_persona = ClientePersona.new(params[:cliente_persona])
    end
    @persona.cliente_persona = @cliente_persona
    @persona.save_new(params[:cliente_persona][:tipo_cliente_id])
    value = true
    if @persona.errors.count > 0
      value = false
    end
    form_save_new @persona, :value=>value
  end
  
  def delete
    @persona = Persona.find(params[:id])
    @cliente_persona = @persona.cliente_persona
    form_delete @persona, @cliente_persona.destroy
  end
  
  def edit
    @persona = Persona.find(params[:id])
    @cliente_persona = @persona.cliente_persona

    fill
    actividad_economica_fill(@persona.sector_economico_id) unless @persona.sector_economico_id.nil?
  end
  
  def save_edit
    @persona = Persona.find(params[:id])
    @cliente_persona = @persona.cliente_persona
    result = @persona.update_all(params[:persona], params[:cliente_persona])
    logger.debug "----------------------------------------------------------------------"
    logger.debug result.class.name
    if result.blank?
      result = false
    end
    form_save_edit @persona, 
      :value=> result
  end
  
  def view
    @persona = Persona.find(params[:id])
    @grupo = ViewGrupo.find(:first, :conditions=>['persona_id = ?', @persona.id])
  end
  
  def tipo_credito_change  
    @persona = Persona.new
    if  params[:tipo_credito_id] == "2"          
      render :update do |page|
  			page.hide 'error'
  			page.replace_html "intermediado", :partial => "intermediado"
  			page.show "intermediado"
  		end
    else
      render :update do |page|
  			page.hide 'error'
  			page.hide "intermediado"
      end
    end        
  end

  def tasa_historico_list
    @persona = Persona.find(params[:id])
    conditions = ["tasa_historico.persona_id = ?", @persona.id]
    joins = ["INNER JOIN tasa_valor ON tasa_historico.tasa_valor_id = tasa_valor.id"]
    params['sort'] = "tasa_valor.fecha_resolucion_desde DESC" unless params['sort']
    @tasa_historico_total = TasaHistorico.count(:conditions=>conditions, :joins=>joins)
    @tasa_historico_pages, @tasa_historico_list = paginate(:tasa_historico, :class_name => 'TasaHistorico',
      :conditions => conditions,
      :joins=>joins,
      :select=>'tasa_historico.*',
      :order_by => params['sort'])

    if request.xml_http_request?
  		render :update do |page|
  			page.replace_html "tasa_historico_list", :partial => "basico/persona/tasa_historico/list"
  		end
    end
  end
  
  def sexo_change
    sexo = params[:sexo]
    if sexo == 'true'
      nacionalidad = I18n.t('Sistema.Body.Vistas.General.masculino')
    else
      nacionalidad = I18n.t('Sistema.Body.Vistas.General.femenino')   
    end
 
    nacionalidad_fill(nacionalidad)
    render :update do |page|
      page.replace_html 'nacionalidad-select', :partial => 'nacionalidad_select'
    end  

  end

  def sector_economico_change
    sector_economico_id = params[:sector_economico_id]
    actividad_economica_fill(sector_economico_id)
    render :update do |page|    
      page.replace_html 'actividad_economica-select', :partial => 'actividad_economica_select'
    end  
  end

  def actividad_economica_change
    actividad_economica_id = params[:actividad_economica_id]
    rama_actividad_economica_fill(actividad_economica_id)
    render :update do |page|    
      page.replace_html 'rama_actividad_economica-select', :partial => 'rama_actividad_economica_select'
    end  
  end

  def printer
    @persona = Persona.find(params[:id])
    @cliente = Cliente.find(:first, :conditions=>['persona_id = ?', @persona.id])
    @persona_direccion = PersonaDireccion.find(:first, :conditions=>['persona_id = ?', @persona.id])
   
    @UnidadProduccion = UnidadProduccion.find(:first, :conditions=>['cliente_id = ?', @cliente.id])
    @CuentaBancaria = CuentaBancaria.find(:first, :conditions=>['cliente_id = ?', @cliente.id])
   
    
    render  :layout => 'form_reporte'
  end

  protected
  def common
    super
    @form_title = "#{I18n.t('Sistema.Body.General.beneficiario')} #{I18n.t('Sistema.Body.General.natural')}"
    @form_title_record = "#{I18n.t('Sistema.Body.General.beneficiario')} #{I18n.t('Sistema.Body.General.natural')}"
    @form_title_records = "#{I18n.t('Sistema.Body.General.beneficiario')} #{I18n.t('Sistema.Body.General.natural')}"
    @form_entity = 'persona'
    @form_identity_field = 'nombre_corto'    
    @records_by_page=15
    @width_layout = '1100'
  end 
 
  private
  def fill
    @tipo_cliente_list = TipoCliente.find(:all, :conditions=>["clasificacion = 'N'"], :order=>'nombre')
    #@ciiu_list = Ciiu.find(:all, :order=>'codigo')
    @profesion_select = Profesion.find(:all, :order=>'nombre')
    @nacionalidad_select = Nacionalidad.find_by_sql("select id, masculino as descripcion from nacionalidad" )
    @pais_list = Pais.find(:all, :order=>'nombre')
  end
  
  def actividad_economica_fill(sector_economico_id)
    if sector_economico_id.to_i != 0
      @actividad_economica_select = ActividadEconomica.find(:all,:conditions=>'sector_economico_id = ' + 
          sector_economico_id.to_s, :order=>'descripcion')
    else
      @actividad_economica_select = ActividadEconomica.find(:all, :order=>'descripcion')   
    end
  end
end
