# encoding: utf-8
class Prestamos::ArrimeController < FormTabsController
  
  skip_before_filter :set_charset, :only=>[:check, :sector_change, :sub_sector_change, :rubro_change, :sub_rubro_change ]
  
  def index
    @municipio = Municipio.find(:all, :order => 'nombre')
    fill
  end

  def list  
    parametro = ParametroGeneral.find(:first)
    
    params['sort'] = "nro_solicitud" unless params['sort']
    #@condition = "(rubro like UPPER('%maiz%') or rubro like UPPER('%arroz%') or rubro like upper('%sorgo%') or rubro like upper('%algodon%'))"
    conditions = "solicitud_id > 0 and moneda_id = #{parametro.moneda_id}"

    unless params[:solicitud]=='' || params[:solicitud].nil?
      conditions += " AND nro_solicitud =  #{params[:solicitud].to_i}"
      @form_search_expression << "#{I18n.t('Sistema.Body.Vistas.Form.nro_tramite')} '#{params[:solicitud]}'"
    end

    unless params[:cedula_rif]=='' ||  params[:cedula_rif].nil?
      conditions += " AND cedula_rif LIKE '%#{params[:tipo]+params[:cedula_rif].strip.downcase}%' "
      @form_search_expression << "#{I18n.t('Sistema.Body.Vistas.VisitaSolicitud.Etiquetas.cedula_rif')} '#{params[:tipo]+params[:cedula_rif]}'"
    end

    unless  params[:productor]=='' || params[:productor].nil?
      conditions += " AND LOWER(productor) LIKE '%#{params[:productor].strip.downcase}%'"
      @form_search_expression << "#{I18n.t('Sistema.Body.Vistas.General.beneficiario')} '#{params[:productor]}'"
    end

    unless  params[:unidad_produccion]=='' || params[:unidad_produccion].nil?
      conditions += " AND LOWER(unidad_produccion) LIKE '%#{params[:unidad_produccion].strip.downcase}%'"
      @form_search_expression << "#{ I18n.t('Sistema.Body.Vistas.General.unidad_produccion')} '#{params[:unidad_produccion]}'"
    end
         
    unless params[:sector_id][0].blank? || params[:sector_id][0].to_s.empty?
      sector_id = params[:sector_id][0].to_s
      sector = Sector.find(sector_id)
      conditions << " and sector_id = #{sector_id.to_s}" 
      @form_search_expression << "#{I18n.t('Sistema.Body.Vistas.General.sector')} '#{sector.nombre}'"
    end
    
    unless params[:sub_sector_id][0].blank? || params[:sub_sector_id][0].to_s.empty?
      sub_sector_id = params[:sub_sector_id][0].to_s
      sub_sector = SubSector.find(sub_sector_id)
      conditions += " and sub_sector_id = #{sub_sector_id.to_s}"
      @form_search_expression << "#{I18n.t('Sistema.Body.Vistas.General.sub_sector')} '#{sub_sector.nombre}'"
    end
    
    unless params[:rubro_id][0].blank? || params[:rubro_id][0].to_s.empty?
      rubro_id = params[:rubro_id][0].to_s
      rubro = Rubro.find(rubro_id)
      conditions += " and rubro_id = #{rubro_id.to_s}"
      @form_search_expression << "#{I18n.t('Sistema.Body.Vistas.General.rubro')} '#{rubro.nombre}'"
    end
    
    unless params[:sub_rubro_id][0].blank? || params[:sub_rubro_id][0].to_s.empty?
      sub_rubro_id = params[:sub_rubro_id][0].to_s
      sub_rubro = SubRubro.find(sub_rubro_id)
      conditions += " and sub_rubro_id = #{sub_rubro_id.to_s}"
      @form_search_expression << "#{I18n.t('Sistema.Body.Vistas.General.sub_rubro')} '#{sub_rubro.nombre}'"
    end
    
    unless params[:actividad_id][0].blank? || params[:actividad_id][0].to_s.empty?
      actividad_id = params[:actividad_id][0].to_s
      actividad = Actividad.find(actividad_id)
      conditions += " and actividad_id = #{actividad_id.to_s}"
      @form_search_expression << "#{I18n.t('Sistema.Body.Vistas.General.actividad')} '#{actividad.nombre}'"
    end

    unless params[:municipio_id][0].blank? || params[:municipio_id][0].to_s.empty?
      municipio_id = params[:municipio_id][0].to_s
      municipio = Municipio.find(municipio_id)
      conditions += " and municipio_id = #{municipio_id}"
      @form_search_expression << "#{I18n.t('Sistema.Body.Vistas.General.municipio')} '#{municipio.nombre}'"
    end
  
    @list = ViewBoletaArrime.search(conditions, params[:page], params[:sort])
    @total=@list.count
    form_list
  end


  def view
    @boleta_arrime = ViewBoletaArrime.find_by_solicitud_id(params[:solicitud_id])
  end
      
  def sector_change
    sub_sector_fill(params[:sector_id])
    render :update do |page|
      page.replace_html 'sub-sector-search', :partial => 'sub_sector_search'
    end
  end
  def sub_sector_change
    @rubro_list = Rubro.find(:all, :conditions=>"sub_sector_id = #{params[:sub_sector_id]}", :order=>'nombre')
    render :update do |page|
      page.replace_html 'rubro-search', :partial => 'rubro_search'
    end
  end
  def rubro_change
    @sub_rubro_list = SubRubro.find(:all, :conditions=>"rubro_id = #{params[:rubro_id]}", :order=>'nombre')
    render :update do |page|
      page.replace_html 'sub-rubro-search', :partial => 'sub_rubro_search'
    end
  end
  def sub_rubro_change
    @actividad_list = Actividad.find(:all, :conditions=>"sub_rubro_id = #{params[:sub_rubro_id]}", :order=>'nombre')
    render :update do |page|
      page.replace_html 'actividad-search', :partial => 'actividad_search'
    end
  end
  
  
  def check
    @formato = FormatoBoleta.find(:first, :conditions=>"actividad_id = #{params[:actividad_id]} and status = true")
    #dir = (Rails.root + "/app/views/prestamos/boleta_arrime/_#{@formato.formato_operacion}.html.erb")
    #logger.info"XXXXXXXX==============================>>>>>>>>>"<<dir.inspect
    if @formato.nil? || @formato.blank? || @formato.to_s.empty?
      error_fill
    end
    if @formato.formato_operacion.to_s.empty?
      error_fill
    else
      #(Rails.root.join('app','views','prestamos','boleta_arrime',"_#{@formato.formato_operacion}.html.erb"))
      #fo = FileTest::exists?(Rails.root + "/app/views/prestamos/boleta_arrime/_#{@formato.formato_operacion}.html.erb")
      fo = FileTest::exists?(Rails.root.join('app','views','prestamos','boleta_arrime',"_#{@formato.formato_operacion}.html.erb"))
      #      fr = FileTest::exists?(RAILS_ROOT + "/app/views/prestamos/boleta_arrime/_#{@formato.formato_resultado}.rhtml")
      if (fo == true)
        render :update do |page|
          page.redirect_to :controller => 'boleta_arrime', :action => :index, :solicitud_id => params[:solicitud_id], :productor =>params[:productor], 
            :rubro_id => params[:rubro_id], :actividad_id => params[:actividad_id], :cliente_id => params[:cliente_id], :nro_solicitud => params[:nro_solicitud]
        end
      else
        error_fill
      end
    end
  end

  def error_fill
    @formato.errors.add(:boleta_arrime, "#{I18n.t('Sistema.Body.Modelos.BoletaArrime.Messages.no_existe_formato')}")
    render :update do |page|
      page.alert I18n.t('Sistema.Body.Modelos.BoletaArrime.Messages.no_existe_formato')
      page.form_error 
      page.<< "window.scrollTo(0,0);"
    end
    
  end

  protected 
  def common
    super
    @form_title = I18n.t('Sistema.Body.Vistas.Arrime.HeaderArrime.form_title')
    @form_title_record = I18n.t('Sistema.Body.Vistas.Arrime.HeaderArrime.form_title_record')
    @form_title_records = I18n.t('Sistema.Body.Vistas.Arrime.HeaderArrime.form_title_record')
    @form_entity = 'boleta_arrime'
    @form_identity_field = 'id'
    @width_layout = '1000'
  end

  def fill
    @sector_list = Sector.find(:all, :order=>'nombre')
    sub_sector_fill(0)
  end
  def sub_sector_fill(sector_id)
    if (sector_id.to_i > 0)
      @sub_sector_list = SubSector.find(:all, :conditions=>['sector_id = ?', sector_id], :order=>'nombre')
    else
      @sub_sector_list = []
      rubro_fill(0)
    end 
  end
  def rubro_fill(sub_sector_id)
    if sub_sector_id.to_i > 0
      @rubro_list = Rubro.find(:all, :conditions=>['sub_sector_id = ?', sub_sector_id], :order=>'nombre')
    else
      @rubro_list = []
      sub_rubro_fill(0)
    end
  end
  def sub_rubro_fill(rubro_id)
    if rubro_id > 0
      @sub_rubro_list = SubRubro.find(:all, :conditions=>['rubro_id = ?', rubro_id], :order=>'nombre')
    else
      @sub_rubro_list = []
      actividad_fill(0)
    end
  end
  def actividad_fill(sub_rubro_id)
    if sub_rubro_id > 0
      @actividad_list = Actividad.find(:all, :conditions=>['sub_rubro_id = ?', sub_rubro_id], :order=>'nombre')
    else
      @actividad_list = []
    end
  end

end


