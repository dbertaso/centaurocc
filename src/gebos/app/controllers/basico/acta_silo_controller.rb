# encoding: utf-8
class Basico::ActaSiloController < FormTabTabsController
  
  skip_before_filter :set_charset, :only=>[:sector_change, :sub_sector_change, :rubro_change, :sub_rubro_change, :tabs ]
  
  def index
    @silo = Silo.find(params[:silo_id])
    list
  end
  
  def list
    params['sort'] = "silo.nombre, acta_silo.id" unless params['sort']
    conditions = "silo.id =#{params[:silo_id]}"
    
    @list = ActaSilo.search(conditions, params[:page], params[:sort])
    @total=@list.count
    form_list
  end
  
  def new
    @silo = Silo.find(params[:silo_id])
    @ciclo_productivo = CicloProductivo.find(:all)
    @acta_silo = ActaSilo.new
    fill
  end
    
  def cancel_new
    form_cancel_new
  end

  def save_new
    @acta_silo = ActaSilo.new(params[:acta_silo])
    @acta_silo.silo_id = params[:silo_id]
    form_save_new @acta_silo
  end

  def delete
    @acta_silo = ActaSilo.find(params[:id])
    result = @acta_silo.eliminar(params[:id])
    if result == false
      render :update do |page|
        page.form_error
      end
      return
    else
      render :update do |page|
        page.form_delete @acta_silo, 'acta_silo'
      end
    end
  end
  
  def edit
    @acta_silo = ActaSilo.find(params[:id])
    @silo = @acta_silo.silo
    @ciclo_productivo = CicloProductivo.find(:all)
    fill
  end
  
  def view
    @acta_silo = ActaSilo.find(params[:id])
    @silo = @acta_silo.silo
  end
  
  def save_edit
    @acta_silo = ActaSilo.find(params[:id])
    logger.info"XXXXXXX-LLEGO-SAVE-!!========>>>>>"<<params.inspect
    form_save_edit @acta_silo
  end

  def cancel_edit
    @acta_silo = ActaSilo.find(params[:id])
    form_cancel_edit @acta_silo
  end
  
  def sector_change
    sub_sector_fill(params[:sector_id])
    render :update do |page|
      page.replace_html 'sub-sector-search', :partial => 'sub_sector_search'
    end
  end
  def sub_sector_change
    @rubro_list = Rubro.find(:all, :conditions=>"sub_sector_id = #{params[:sub_sector_id]}")
    render :update do |page|
      page.replace_html 'rubro-search', :partial => 'rubro_search'
    end
  end
  def rubro_change
    @sub_rubro_list = SubRubro.find(:all, :conditions=>"rubro_id = #{params[:rubro_id]}")
    render :update do |page|
      page.replace_html 'sub-rubro-search', :partial => 'sub_rubro_search'
    end
  end
  def sub_rubro_change
    @actividad_list = Actividad.find(:all, :conditions=>"sub_rubro_id = #{params[:sub_rubro_id]}")
    render :update do |page|
      page.replace_html 'actividad-search', :partial => 'actividad_search'
    end
  end

   
  protected
  def common
    super
    @form_title = I18n.t('Sistema.Body.Controladores.ActaSilo.FormTitles.form_title')
    @form_title_record = I18n.t('Sistema.Body.Controladores.ActaSilo.FormTitles.form_title_record')
    @form_title_records = I18n.t('Sistema.Body.Controladores.ActaSilo.FormTitles.form_title_records')
    @form_entity = 'acta_silo'
    @form_identity_field = 'nombre'
    @width_layout = '850'
  end
  
  def fill
    @sector_list = Sector.find(:all, :order=>'nombre')
    unless @acta_silo.id.nil?
      @solicitud = Solicitud.new
      @solicitud.sector_id = @acta_silo.actividad.sub_rubro.rubro.sub_sector.sector_id
      sector_id = @acta_silo.actividad.sub_rubro.rubro.sector_id
      sub_sector_fill(sector_id)
    else
      sub_sector_fill(0)
    end
  end
  def sub_sector_fill(sector_id)
    if (sector_id.to_i > 0)
      @sub_sector_list = SubSector.find(:all, :conditions=>['sector_id = ?', sector_id], :order=>'nombre')
      unless @acta_silo.nil?
        @solicitud.sub_sector_id = @acta_silo.actividad.sub_rubro.rubro.sub_sector_id
        sub_sector_id = @acta_silo.actividad.sub_rubro.rubro.sub_sector_id
        rubro_fill(sub_sector_id)
      end
    else
      @sub_sector_list = []
      rubro_fill(0)
    end 
  end
  def rubro_fill(sub_sector_id)
    if sub_sector_id.to_i > 0
      @rubro_list = Rubro.find(:all, :conditions=>['sub_sector_id = ?', sub_sector_id], :order=>'nombre')
      unless @acta_silo.nil?
        @solicitud.rubro_id = @acta_silo.actividad.sub_rubro.rubro_id
        rubro_id = @acta_silo.actividad.sub_rubro.rubro_id
        sub_rubro_fill(rubro_id)
      end
    else
      @rubro_list = []
      sub_rubro_fill(0)
    end
  end
  def sub_rubro_fill(rubro_id)
    if rubro_id > 0
      @sub_rubro_list = SubRubro.find(:all, :conditions=>['rubro_id = ?', rubro_id], :order=>'nombre')
      unless @acta_silo.nil?
        @solicitud.sub_rubro_id = @acta_silo.actividad.sub_rubro_id
        sub_rubro_id = @acta_silo.actividad.sub_rubro_id
        actividad_fill(sub_rubro_id)
      end
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
