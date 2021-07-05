# encoding: utf-8

#
# autor: Marvin Alfonzo
# clase: Maquinaria::EnvioMaquinariaController
# descripción: Migración a Rails 3
#


class Maquinaria::EnvioMaquinariaController < FormTabsController
  
  skip_before_filter :set_charset, :only=>[:estado_change, :municipio_change]
  
  
  def index 
    fill
  end

  def list
    @condition = "solicitud_id > 0"
    params['sort'] = "estatus_id" unless params['sort']
    unless params[:solicitud].nil? || params[:solicitud].to_s.empty?
      @condition << " AND nro_tramite =  #{params[:solicitud].to_s}"      
    end
    unless params[:cedula_rif].to_s.empty? || params[:cedula_rif].nil?
      @condition << " AND cedula_rif ILIKE '%#{params[:tipo]+params[:cedula_rif].strip.downcase}%'"      
    end
    unless  params[:productor]=='' || params[:productor].nil?
      @condition << " AND LOWER(productor) LIKE '%#{params[:productor].strip.downcase}%'"      
    end
    unless  params[:unidad_produccion]=='' || params[:unidad_produccion].nil?
      @condition << " AND LOWER(unidad_produccion) LIKE '%#{params[:unidad_produccion].strip.downcase}%'"      
    end        
    unless params[:estado_id].nil?
      unless params[:estado_id][0].to_s==''      
      @condition << " and estado_id = #{params[:estado_id][0]}"      
      end
    end 
    unless params[:municipio_id].nil? 
      unless params[:municipio_id][0].to_s==''      
      @condition << " and municipio_id = #{params[:municipio_id][0]}"      
      end
    end
    unless params[:parroquia_id].nil?
      unless params[:parroquia_id][0].to_s==''      
      @condition << " and parroquia_id = #{params[:parroquia_id][0]}"      
      end
    end
    logger.debug "condiciones " << @condition.to_s
    
    
    @list = ViewEnvioMaquinaria.search(@condition, params[:page], params['sort'])
    @total=@list.count

    form_list
  end 
  
  def estado_change
    unless params[:estado_id].to_s ==''
      municipio_fill(params[:estado_id])
      @parroquia_list = []
    else
      @municipio_list = []
      @parroquia_list =[]
    end   
    
    
    render :update do |page|
      page.replace_html 'municipio-search', :partial => 'municipio_search'
      page.replace_html 'parroquia-search', :partial => 'parroquia_search'
    end
  end
  
  def municipio_change
    unless params[:municipio_id].to_s ==''
      @parroquia_list = Parroquia.find(:all, :conditions=>"municipio_id = #{params[:municipio_id]}", :order=>'nombre')
    else
      @parroquia_list =[]
    end   
    
    render :update do |page|
      page.replace_html 'parroquia-search', :partial => 'parroquia_search'
    end
  end

  protected 
  def common
    super
    @form_title = I18n.t('Sistema.Body.Controladores.EnvioMaquinaria.FormTitles.form_title') #'Solicitud de Envío de Maquinarias'
    @form_title_record = I18n.t('Sistema.Body.Modelos.Errores.tramite_sin_b')
    @form_title_records = I18n.t('Sistema.Body.Modelos.Errores.tramite_sin_b')
    @form_entity =  'view_envio_maquinaria'
    @form_identity_field = 'id'
    @width_layout = '1000'
  end

  def fill
    @estado_list = Estado.find(:all, :order => 'nombre')
    municipio_fill(0)
  end
  def municipio_fill(estado_id)
    if (estado_id.to_i > 0)
      @municipio_list = Municipio.find(:all, :conditions=>['estado_id = ?', estado_id], :order=>'nombre')
    else
      @municipio_list = []
      parroquia_fill(0)
    end 
  end
  def parroquia_fill(municipio_id)
    if municipio_id.to_i > 0
      @parroquia_list = Parroquia.find(:all, :conditions=>['municipio_id = ?', municipio_id], :order=>'nombre')
    else
      @parroquia_list = []
    end
  end
end


