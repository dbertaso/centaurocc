# encoding: utf-8

class Basico::FormatoBoletaController < FormAjaxController
  
  skip_before_filter :set_charset, :only=>[:sector_change, :sub_sector_change, :rubro_change, :sub_rubro_change]

  def index
    list
  end

  def list
    params['sort'] = "formato_boleta.actividad_id" unless params['sort'] 
    
    @list = FormatoBoleta.search(params[:page], params[:sort])
    @total=@list.count
   
    form_list
  end

  def new
    @formato_boleta = FormatoBoleta.new
    fill
    form_new @formato_boleta
  end

  def save_new
    @formato_boleta = FormatoBoleta.new(params[:formato_boleta])
    @formato_boleta.usuario_id = session[:id]
    form_save_new @formato_boleta
  end
  
  def cancel_new
		form_cancel_new
  end
  
  def delete
    @formato_boleta = FormatoBoleta.find(params[:id])
    form_delete @formato_boleta
  end
  
  def edit
    @formato_boleta = FormatoBoleta.find(params[:id])
    fill
    form_edit @formato_boleta
  end

  def save_edit
    @formato_boleta = FormatoBoleta.find(params[:id])
    form_save_edit @formato_boleta
  end
  
  def cancel_edit
    @formato_boleta = FormatoBoleta.find(params[:id])
    form_cancel_edit @formato_boleta
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
    @form_title = I18n.t('Sistema.Body.Controladores.FormatoBoleta.FormTitles.form_title')
    @form_title_record = I18n.t('Sistema.Body.Controladores.FormatoBoleta.FormTitles.form_title')
    @form_title_records = I18n.t('Sistema.Body.Controladores.FormatoBoleta.FormTitles.form_title')
    @form_entity = I18n.t('Sistema.Body.Controladores.FormatoBoleta.FormTitles.form_entity')
    @form_identity_field = I18n.t('Sistema.Body.Controladores.FormatoBoleta.FormTitles.form_identity_field')
    @width_layout = '900'
  end
  
  def fill
    @sector_list = Sector.find(:all, :order=>'nombre')
    unless @formato_boleta.id.nil?
      @solicitud = Solicitud.new
      @solicitud.sector_id = @formato_boleta.actividad.sub_rubro.rubro.sub_sector.sector_id
      sector_id = @formato_boleta.actividad.sub_rubro.rubro.sector_id
      sub_sector_fill(sector_id)
    else
      sub_sector_fill(0)
    end
  end
  def sub_sector_fill(sector_id)
    if (sector_id.to_i > 0)
      @sub_sector_list = SubSector.find(:all, :conditions=>['sector_id = ?', sector_id], :order=>'nombre')
      unless @formato_boleta.nil?
        @solicitud.sub_sector_id = @formato_boleta.actividad.sub_rubro.rubro.sub_sector_id
        sub_sector_id = @formato_boleta.actividad.sub_rubro.rubro.sub_sector_id
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
      unless @formato_boleta.nil?
        @solicitud.rubro_id = @formato_boleta.actividad.sub_rubro.rubro_id
        rubro_id = @formato_boleta.actividad.sub_rubro.rubro_id
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
      unless @formato_boleta.nil?
        @solicitud.sub_rubro_id = @formato_boleta.actividad.sub_rubro_id
        sub_rubro_id = @formato_boleta.actividad.sub_rubro_id
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
