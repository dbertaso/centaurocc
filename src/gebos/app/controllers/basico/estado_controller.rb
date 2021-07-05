# encoding: utf-8

#
# autor: Marvin Alfonzo
# clase: Basico::EstadoController
# descripción: Migración a Rails 3
#

class Basico::EstadoController < FormTabsController

skip_before_filter :set_charset, :only=>[:region_search]
  
  def list

    params['sort'] = "estado.nombre" unless params['sort']

    unless params[:nombre].nil? || params[:nombre].blank?
      conditions = ["LOWER(estado.nombre) LIKE ?", "%"<<params[:nombre].to_s.strip.downcase<<"%"]
      @form_search_expression << "Nombre contenga '#{params[:nombre]}'"
    end

    
    @list = Estado.search(conditions, 
                            params[:page], 
                            params['sort'])
    @total=@list.count
    form_list

  end
  
  def new
    fill_pais
    @region_list = []
    @estado = Estado.new
  end

  def save_new    
    @estado = Estado.new(params[:estado])    
    form_save_new @estado
  end
  
  def delete
    @estado = Estado.find(params[:id])
    form_delete @estado
  end
  
  def edit
    fill_pais    
    @estado = Estado.find(params[:id])
    @region_list = Region.find(:all,:conditions=>"pais_id=#{@estado.pais_id}", :order=>'nombre')    
  end
  
  def view
    @estado = Estado.find(params[:id])
  end
  
  def save_edit
    @estado = Estado.find(params[:id])
    form_save_edit @estado
  end

  def region_search
    
    if params[:id].to_s ==''        
    @region_list = []
    else      
    @region_list = Region.find(:all,:conditions=>"pais_id = #{params[:id].to_s}" ,:order=>'nombre')
  end
    
    render :update do |page|
      page.replace_html 'region-search', :partial => 'region_search'      
    end
  end

  protected
  def common
    super
    @form_title = I18n.t('Sistema.Body.Controladores.Estado.FormTitles.form_title')
    @form_title_record = I18n.t('Sistema.Body.Controladores.Estado.FormTitles.form_title_record')
    @form_title_records = I18n.t('Sistema.Body.Controladores.Estado.FormTitles.form_title_records')
    @form_entity = 'estado'
    @form_identity_field = 'nombre'
  end
  
  private
  def fill_pais   
   @pais=Pais.find(:all,:order=>"nombre")
  end

end
