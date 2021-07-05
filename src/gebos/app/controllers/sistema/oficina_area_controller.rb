# encoding: utf-8
class Sistema::OficinaAreaController < FormTabTabsController
  
  skip_before_filter :set_charset, :only=>[:estado_change, :municipio_change, :tabs ]

  def index
    list
  end

  def list
    _list

    form_list

  end	
  
  def view
    list_view
  end
  
  def list_view
    _list
    form_list_view
  end
  
  def _list
    @oficina = Oficina.find(params[:oficina_id])
    conditions = "oficina_id = #{params[:oficina_id]}"
    params['sort'] = "municipio.nombre" unless params['sort']
    
    @list = OficinaAreaInfluencia.search(conditions, params[:page], params[:sort])
    @total=@list.count
  end

  def new
    @oficina = Oficina.find(params[:oficina_id])
    @oficina_area_influencia = OficinaAreaInfluencia.new
    @estado_list = Estado.find(:all, :conditions=>"region_id = #{@oficina.ciudad.estado.region_id}")
    @municipio_list = []
    @parroquia_list = []
  end
  
  def save_new
    @oficina = Oficina.find(params[:oficina_id])
    @oficina_area_influencia = OficinaAreaInfluencia.new(params[:oficina_area_influencia])
    @oficina_area_influencia.oficina_id = @oficina.id
    if @oficina_area_influencia.save == true
      flash[:notice] = I18n.t('Sistema.Body.Controladores.OficinaArea.FormTitles.save_area')
      render :update do |page|
        page.redirect_to :action=>'index', :oficina_id=>@oficina.id
      end
    else
      render :update do |page|
        page.form_error
      end
      return false
    end
    #    form_save_new @oficina_area_influencia,
    #      :params=> { :oficina_id => @oficina.id }
  end
  
  def edit
    @oficina = Oficina.find(params[:oficina_id])
    @oficina_area_influencia = OficinaAreaInfluencia.find(params[:id])
    @estado_list = Estado.find(:all, :conditions=>"region_id = #{@oficina.ciudad.estado.region_id}")
    municipio_fill(@oficina_area_influencia.estado_id)
  end
  
  def save_edit
    @oficina = Oficina.find(params[:oficina_id])
    @oficina_area_influencia = OficinaAreaInfluencia.find(params[:id])
    #if @oficina_area_influencia.save == true
    if @oficina_area_influencia.update_attributes(params[:oficina_area_influencia]) == true
      flash[:notice] = I18n.t('Sistema.Body.Controladores.OficinaArea.FormTitles.save_area')
      render :update do |page|
        page.redirect_to :action=>'index', :oficina_id=>@oficina.id
      end
    else
      render :update do |page|
        page.form_error
      end
      return false
    end
  end
  
  def delete
    @oficina = Oficina.find(params[:oficina_id])
    @oficina_area_influencia = OficinaAreaInfluencia.find(params[:id])
    form_delete @oficina_area_influencia
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

  protected  
  def common
    super
    @form_title = I18n.t('Sistema.Body.Controladores.OficinaArea.FormTitles.form_title')
    @form_title_record = I18n.t('Sistema.Body.Controladores.OficinaArea.FormTitles.form_title_record')
    @form_title_records = I18n.t('Sistema.Body.Controladores.OficinaArea.FormTitles.form_title_records')
    @form_entity = 'oficina_area_influencia'
    @form_identity_field = 'parroquia.nombre'
    #@width_layout = '890'
  end

  private 
  
  def municipio_fill(estado_id)
    @municipio_list = Municipio.find_all_by_estado_id(estado_id, :order=>'nombre')
    unless @oficina_area_influencia.nil? || @oficina_area_influencia.parroquia_id.nil?
      parroquia_fill(@oficina_area_influencia.municipio_id)
    else
      @parroquia_list = []
    end
    
  end
  
  def parroquia_fill(municipio_id)
    @parroquia_list = Parroquia.find_all_by_municipio_id(municipio_id, :order=>'nombre')
  end

end
